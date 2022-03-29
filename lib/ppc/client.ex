defmodule Ppc.Client do
  alias Ppc.Account

  @callback obtain_token(account :: Account.t()) ::
              {:ok, String.t(), pos_integer()} | {:error, String.t(), String.t()}

  @callback get(url :: String.t(), opts :: keyword) :: {:ok, any} | {:error, any}
  @callback post(url :: String.t(), data :: map, opts :: keyword) :: {:ok, any} | {:error, any}
  @callback patch(url :: String.t(), data :: map, opts :: keyword) :: {:ok, any} | {:error, any}
  @callback delete(url :: String.t(), opts :: keyword) :: {:ok, any} | {:error, any}

  def obtain_token(account), do: impl().obtain_token(account)
  def get(url, opts), do: impl().get(url, opts)
  def post(url, data, opts), do: impl().post(url, data, opts)
  def patch(url, data, opts), do: impl().patch(url, data, opts)
  def delete(url, opts), do: impl().delete(url, opts)

  defp impl, do: Application.get_env(:ppc, :client_impl, Ppc.ClientHTTP)
end
