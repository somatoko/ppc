defmodule Ppc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Ppc.Account

  @env Mix.env()

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ppc.Supervisor]
    Supervisor.start_link(get_children(), opts)
  end

  def paypal_accounts do
    [
      # Account.new_from_line!(:one, System.fetch_env!("ACCOUNT_1"))
      # Account.new_from_line!(:two, System.fetch_env!("ACCOUNT_2"))
      Account.new_from_line!(:default, System.fetch_env!("ACCOUNT_1"))
    ]
  end

  defp get_children do
    cond do
      @env in [:test, :prod] ->
        [{Finch, name: PpcFinch, pools: %{:default => [size: 4]}}]

      @env == :dev ->
        [
          {Finch, name: PpcFinch, pools: %{:default => [size: 4]}}
          # {Ppc.AccountStore, [accounts: &paypal_accounts/0]}
        ]

      @env == :dev_lib ->
        [
          {Finch, name: PpcFinch, pools: %{:default => [size: 4]}},
          {Ppc.AccountStore, [accounts: &paypal_accounts/0]}
        ]
    end
  end
end
