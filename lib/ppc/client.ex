defmodule Ppc.Client do
  alias Ppc.Account

  @callback obtain_token(account :: Account.t()) ::
              {:ok, String.t(), pos_integer()} | {:error, String.t(), String.t()}

  @callback get(account :: Account.t(), url :: String.t()) :: {:ok, any} | {:error, any}
  @callback get(account :: Account.t(), url :: String.t(), opts :: keyword) ::
              {:ok, any} | {:error, any}

  @callback post(account :: Account.t(), url :: String.t(), data :: map) ::
              {:ok, any} | {:error, any}
  @callback post(account :: Account.t(), url :: String.t(), data :: map, opts :: keyword) ::
              {:ok, any} | {:error, any}

  @callback patch(account :: Account.t(), url :: String.t(), data :: map) ::
              {:ok, any} | {:error, any}
  @callback patch(account :: Account.t(), url :: String.t(), data :: map, opts :: keyword) ::
              {:ok, any} | {:error, any}

  def obtain_token(account), do: impl().obtain_token(account)
  def get(account, url, opts \\ []), do: impl().get(account, url, opts)
  def post(account, url, data, opts \\ []), do: impl().post(account, url, data, opts)
  def patch(account, url, data, opts \\ []), do: impl().patch(account, url, data, opts)

  defp impl, do: Application.get_env(:ppc, :client_impl, Ppc.ClientHTTP)
end
