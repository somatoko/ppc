defmodule Ppc.ApiHost do
  alias Ppc.Account

  @callback host_for(Account.t()) :: String.t()
  @callback host_live() :: String.t()
  @callback host_sandbox() :: String.t()

  def host_for(a), do: impl().host_for(a)
  def host_live(), do: impl().host_live()
  def host_sandbox(), do: impl().host_sandbox()

  defp impl, do: Application.get_env(:ppc, :api_host, Ppc.ApiHostImpl)
end
