defmodule Ppc.ClientHTTP do
  require Logger

  @behaviour Ppc.Client

  alias Ppc.{Account, ApiHost}

  @impl Ppc.Client
  # @spec obtain_token(Ppc.Account.t()) :: {String.t() | nil, pos_integer()}
  # @spec obtain_token(Ppc.Account.t()) ::
  #         {:error, String.t(), String.t()} | {:ok, String.t(), pos_integer()}
  def obtain_token(account) do
    construct_token_request(account)
    |> Finch.request(PpcFinch)
    |> case do
      {:ok, %{status: status, body: body_json}} ->
        body = Jason.decode!(body_json)

        case status do
          200 ->
            {:ok, body["access_token"], body["expires_in"]}

          401 ->
            {:error, body["error"], body["error_description"]}

          429 ->
            {:error, body["error"], body["error_description"]}

          _ ->
            {:error, body["error"], body["error_description"]}
        end

      {:error, reason} ->
        # %Mint.TransportError{reason: :nxdomain}
        # Logger.warn("Connection error #{reason}; retrying after 10 sec.")
        # {nil, 10}
        {:error, "unknown", reason}
    end
  end

  @impl Ppc.Client
  def get(suffix, opts) do
    make_request(suffix, :get, nil, opts)
  end

  @impl Ppc.Client
  def post(path, data, opts) do
    make_request(path, :post, data, opts)
  end

  @impl Ppc.Client
  def patch(path, data, opts) do
    make_request(path, :patch, data, opts)
  end

  @impl Ppc.Client
  def delete(path, opts) do
    make_request(path, :delete, nil, opts)
  end

  @spec make_request(String.t(), atom, map | nil, keyword()) :: {:ok, any} | {:error, any}
  def make_request(suffix, method, data, opts) do
    account = get_account(opts)

    url =
      (base_host(account) <> suffix)
      |> attach_url_params(opts[:params])

    headers = construct_headers_for_work(account)
    headers = headers ++ Keyword.get(opts, :headers, [])
    body = data && Jason.encode!(data)

    keys = Keyword.get(opts, :keys, :strings)

    Finch.build(method, url, headers, body)
    |> Finch.request(PpcFinch)
    |> handle_finch_response(
      account: account,
      suffix: suffix,
      method: method,
      data: data,
      keys: keys
    )
  end

  @spec handle_finch_response(any) :: {:ok, any} | {:error, any}
  @spec handle_finch_response(any, keyword()) :: {:ok, any} | {:error, any}
  def(handle_finch_response(resp, opts \\ [])) do
    case resp do
      {:ok, %{status: 200, body: body}} ->
        {:ok, Jason.decode!(body, keys: opts[:keys])}

      {:ok, %{status: 201, body: body}} ->
        {:ok, Jason.decode!(body, keys: opts[:keys])}

      {:ok, %{status: 204}} ->
        {:ok, :no_content}

      {:ok, %{status: 400, body: body}} ->
        body = Jason.decode!(body)

        case body["details"] do
          [] ->
            {:ok, :no_changes}

          [details | _] ->
            {:error, details}
        end

      {:ok, %{status: 401, body: body}} ->
        Jason.decode!(body, keys: :atoms)
        |> IO.inspect(label: "> status 401")

        {:ok, :unauthorized}

      {:ok, %{status: 403, body: body}} ->
        Jason.decode!(body, keys: :atoms)
        |> IO.inspect(label: "> status 403")

        {:ok, :unauthorized}

      {:ok, %{status: 404, body: body}} ->
        body = Jason.decode!(body)
        [details | _] = body["details"]
        {:error, details["description"]}

      {:ok, %{status: 422, body: body}} ->
        body = Jason.decode!(body)
        [details | _] = body["details"]
        {:error, details}

      {:error, %Mint.TransportError{reason: :closed}} ->
        Logger.warn("Ppc.ClientHTTP: closed socket; retrying in 1 sec.")
        Process.sleep(1000)
        make_request(opts.suffix, opts.method, opts.data, keys: opts.keys)

      {:error, %Mint.TransportError{reason: :timeout}} ->
        Logger.warn("Ppc.ClientHTTP: request timeout; retrying in 1 sec.")
        Process.sleep(1000)
        make_request(opts.suffix, opts.method, opts.data, keys: opts.keys)

      resp ->
        {:error, resp}
    end
  end

  @spec attach_url_params(String.t(), keyword()) :: String.t()
  def attach_url_params(url, opts \\ []) do
    opts = if is_nil(opts), do: [], else: opts
    # params = URI.encode_query(opts) |> String.replace("%3A", ":")
    params = URI.encode_query(opts)

    params =
      if String.length(params) == 0 do
        ""
      else
        "?" <> params
      end

    url <> params
  end

  @spec base_host(Account.t()) :: String.t()
  def base_host(account) do
    ApiHost.host_for(account)
  end

  defp construct_token_request(account) do
    Finch.build(
      :post,
      "#{base_host(account)}/v1/oauth2/token",
      construct_headers_for_auth(account),
      "grant_type=client_credentials"
    )
  end

  @doc """
  Prepare request headers to authenticate the client.
  """
  @spec construct_headers_for_auth(Ppc.Account.t()) :: [{String.t(), String.t()}]
  def construct_headers_for_auth(account) do
    credentials = encode_credentials(account.client_id, account.secret)

    [
      {"Accept", "application/json"},
      {"Accept-Language", "en_US"},
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Authorization", "Basic #{credentials}"}
    ]
  end

  @doc """
  Prepare request headers that will be used for casual operations.
  """
  @spec construct_headers_for_work(Ppc.Account.t()) :: [{String.t(), String.t()}]
  def construct_headers_for_work(account) do
    [
      {"Content-Type", "application/json"},
      {"Accept-Language", "en_US"},
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{account.token}"}
    ]
  end

  @spec encode_credentials(String.t(), String.t()) :: String.t()
  def encode_credentials(name, pass) do
    "#{name}:#{pass}"
    |> Base.encode64()
  end

  @spec seconds_before_next_update(%{atom => Account.t()}) :: pos_integer()
  def seconds_before_next_update(account_list) do
    Enum.map(account_list, fn {_name, x} -> x.expires_at end)
    |> Enum.sort()
    |> case do
      [first | _rest] ->
        first

      _ ->
        # cooldawn 30sec.
        NaiveDateTime.add(NaiveDateTime.utc_now(), 30)
    end
    |> NaiveDateTime.diff(NaiveDateTime.utc_now())
  end

  def get_account(opts) do
    cond do
      Keyword.has_key?(opts, :account) ->
        Ppc.Account.get(opts[:account])

      not is_nil(Ppc.Account.get(:default)) ->
        Ppc.Account.get(:default)

      true ->
        raise ArgumentError, message: "No paypal account supplied."
    end
  end
end
