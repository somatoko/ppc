defmodule Ppc.Account do
  alias Ppc.{AccountStore, Client}

  defstruct client_id: "", secret: "", realm: "", token: "", name: :default, expires_at: nil

  @type t :: %__MODULE__{
          client_id: String.t(),
          secret: String.t(),
          token: String.t(),
          realm: String.t(),
          name: atom(),
          expires_at: NaiveDateTime.t() | nil
        }

  @spec new(atom(), String.t(), String.t(), String.t()) :: __MODULE__.t()
  def new(name, realm, client_id, secret) do
    %__MODULE__{
      client_id: client_id,
      secret: secret,
      realm: realm,
      name: name,
      expires_at: NaiveDateTime.utc_now()
    }
  end

  @spec new_from_line!(atom(), String.t()) :: __MODULE__.t()
  def new_from_line!(name, line) do
    regex = ~r/(?<realm>\w+)@(?<id>[\w-_]+)@(?<pass>[\w-_]+)/
    parts = Regex.named_captures(regex, line)

    if is_nil(parts) do
      raise "Unable to initialize paypal credentials."
    else
      new(name, parts["realm"], parts["id"], parts["pass"])
    end
  end

  @spec get(atom) :: nil | __MODULE__.t()
  def get(name) do
    AccountStore.get_account(name)
  end

  @spec update_token_if_needed(__MODULE__.t()) :: __MODULE__.t()
  def update_token_if_needed(account) do
    # Bug: NaiveDateTime.compare/2 is more accurate than </2, >/2
    if is_nil(account.expires_at) ||
         NaiveDateTime.compare(account.expires_at, NaiveDateTime.utc_now()) == :lt do
      {token, seconds} =
        case Client.obtain_token(account) do
          {:ok, token, seconds} ->
            {token, seconds}

          {:error, _name, _reason} ->
            {nil, 60}
        end

      expires_at = NaiveDateTime.add(NaiveDateTime.utc_now(), seconds)
      %{account | expires_at: expires_at, token: token}
    else
      account
    end
  end

  @spec use_token_for_seconds(__MODULE__.t(), nil | String.t(), pos_integer()) ::
          __MODULE__.t()
  def use_token_for_seconds(account, token, seconds) do
    expires_at = NaiveDateTime.add(NaiveDateTime.utc_now(), seconds)
    %{account | expires_at: expires_at, token: token}
  end
end
