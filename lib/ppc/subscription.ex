defmodule Ppc.Subscription do
  @moduledoc """

  ## Reference

    - [API docs](https://developer.paypal.com/api/subscriptions/v1/)
  """

  alias Ppc.{Account, Client, Common}

  @base_path "/v1/billing/subscriptions"

  def details(account, id) do
    Client.get(account, @base_path <> "/#{id}")
  end

  @doc """
  Create a plan that will be used by user to approve.

  The only required parameter is :plan_id that references the desired plan.

  Will create a subscription with status "APPROVAL_PENDING".
  """
  @spec create(Account.t(), map) :: any
  @spec create(Account.t(), map, keyword) :: any
  def create(account, %{plan_id: plan_id}, opts \\ nil) do
    Client.post(
      account,
      @base_path,
      %{plan_id: plan_id},
      headers: Common.construct_headers_for_create(opts)
    )
  end

  @doc """
  Updates the quantity of the product or service in a subscription. You can also
  use this method to switch the plan and update the shipping_amount, shipping_address
  values for the subscription. This type of update requires the buyer's consent.
  """
  @spec revise(Account.t(), String.t(), String.t()) :: any
  def revise(account, id, reason) do
    Client.post(account, @base_path <> "/#{id}/revise", %{reason: reason})
  end

  @spec activate(Account.t(), String.t(), String.t()) :: any
  def activate(account, id, reason) do
    Client.post(account, @base_path <> "/#{id}/activate", %{reason: reason})
  end

  @spec suspend(Account.t(), String.t(), String.t()) :: any
  def suspend(account, id, reason) do
    Client.post(account, @base_path <> "/#{id}/suspend", %{reason: reason})
  end

  @doc """
  Cancels a subscription forever. Canceled subscriptions can't be activated again.

  Use sespend to soft-cancel a subscription.
  """
  @spec cancel(Account.t(), String.t(), String.t()) :: any
  def cancel(account, id, reason) do
    Client.post(account, @base_path <> "/#{id}/cancel", %{reason: reason})
  end

  def transactions(account, id, opts \\ []) do
    start_time = Keyword.get(opts, :start_time, Common.datetime_add_days(-5))
    end_time = Keyword.get(opts, :end_time, Common.datetime_add_days(1))

    url = @base_path <> "/#{id}/transactions?start_time=#{start_time}&end_time=#{end_time}"
    Client.get(account, url)
  end
end
