defmodule Ppc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Ppc.Account

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ppc.Supervisor]
    Supervisor.start_link(get_children(), opts)
  end

  def paypal_accounts do
    [
      Account.new_from_line!(:one, System.fetch_env!("ACCOUNT_1")),
      Account.new_from_line!(:two, System.fetch_env!("ACCOUNT_2"))
    ]
  end

  defp get_children do
    if Mix.env() == :test do
      [
        {Finch, name: PpcFinch, pools: %{:default => [size: 4]}}
      ]
    else
      [
        {Finch, name: PpcFinch, pools: %{:default => [size: 4]}},
        {Ppc.AccountStore, [accounts: &paypal_accounts/0]}
      ]
    end
  end
end
