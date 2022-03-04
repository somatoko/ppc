defmodule Ppc.Order do
  @moduledoc """

  ## Reference

    - [API docs](https://developer.paypal.com/api/orders/v2/)
  """

  alias Ppc.{Account, Client}

  @base_path "/v2/checkout/orders"

  @spec details(Account.t(), String.t()) :: any
  def details(account, id) do
    Client.get(account, @base_path <> "/#{id}")
  end
end
