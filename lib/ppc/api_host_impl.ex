defmodule Ppc.ApiHostImpl do
  @behaviour Ppc.ApiHost

  def host_live(), do: "https://api-m.paypal.com"
  def host_sandbox(), do: "https://api.sandbox.paypal.com"

  def host_for(account) do
    if account.realm == "live", do: host_live(), else: host_sandbox()
  end
end
