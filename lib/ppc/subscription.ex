defmodule Ppc.Subscription do
  @moduledoc """
  View and manage subscriptions.

  Note that it's not possible to obtail a list of subscriptions. You have to manage a list
  of your subscriptions by your own.

  Other way to obtain ids of active subscriptions is to look to the logs of the paypal hooks,
  that notify about payment transactions.

  ## Reference

    - [Subsriptions API](https://developer.paypal.com/api/subscriptions/v1/)
    - [Web Hooks](https://developer.paypal.com/api/webhooks/v1/)
  """

  alias Ppc.{Client, Common}

  @base_path "/v1/billing/subscriptions"

  def details(id, opts \\ []) do
    Client.get(@base_path <> "/#{id}", opts)
  end

  @doc """
  Create a plan that will be used by user to approve.

  The only required parameter is :plan_id that references the desired plan.

  Will create a subscription with status "APPROVAL_PENDING".
  """
  @spec create(map) :: any
  @spec create(map, keyword) :: any
  def create(%{plan_id: plan_id}, opts \\ []) do
    Client.post(
      @base_path,
      %{plan_id: plan_id},
      Keyword.put(opts, :headers, Common.construct_headers_for_create(opts))
    )
  end

  @doc """
  Updates the quantity of the product or service in a subscription. You can also
  use this method to switch the plan and update the shipping_amount, shipping_address
  values for the subscription. This type of update requires the buyer's consent.
  """
  @spec revise(String.t(), String.t(), keyword) :: any
  def revise(id, reason, opts) do
    Client.post(@base_path <> "/#{id}/revise", %{reason: reason}, opts)
  end

  @spec activate(String.t(), String.t(), keyword) :: any
  def activate(id, reason, opts) do
    Client.post(@base_path <> "/#{id}/activate", %{reason: reason}, opts)
  end

  @spec suspend(String.t(), String.t(), keyword) :: any
  def suspend(id, reason, opts) do
    Client.post(@base_path <> "/#{id}/suspend", %{reason: reason}, opts)
  end

  @doc """
  Cancels a subscription forever. Canceled subscriptions can't be activated again.

  Use sespend to soft-cancel a subscription.
  """
  @spec cancel(String.t(), String.t(), keyword) :: any
  def cancel(id, reason, opts) do
    Client.post(@base_path <> "/#{id}/cancel", %{reason: reason}, opts)
  end

  def transactions(id, opts \\ []) do
    start_time = Keyword.get(opts, :start_time, Common.datetime_add_days(-5))
    end_time = Keyword.get(opts, :end_time, Common.datetime_add_days(1))

    url = @base_path <> "/#{id}/transactions?start_time=#{start_time}&end_time=#{end_time}"
    Client.get(url, opts)
  end
end
