defmodule Ppc.Live do
  @behaviour Ppc

  # ------------------------------------ product --------------------------------------

  @impl Ppc
  def product_list(opts \\ []) do
    Ppc.Product.list(opts)
  end

  @impl Ppc
  def product_details(id, opts \\ []) do
    Ppc.Product.details(id, opts)
  end

  @impl Ppc
  def product_create(data, opts \\ []) do
    Ppc.Product.create(data, opts)
  end

  @impl Ppc
  def product_update(id, data, opts \\ []) do
    Ppc.Product.update(id, data, opts)
  end

  # -------------------------------------- plan --------------------------------------

  @impl Ppc
  def plan_list(opts \\ []) do
    Ppc.Plan.list(opts)
  end

  @impl Ppc
  def plan_details(id, opts \\ []) do
    Ppc.Plan.details(id, opts)
  end

  @impl Ppc
  def plan_activate(id, opts \\ []) do
    Ppc.Plan.activate(id, opts)
  end

  @impl Ppc
  def plan_deactivate(id, opts \\ []) do
    Ppc.Plan.deactivate(id, opts)
  end

  @impl Ppc
  def plan_create(data, opts \\ []) do
    Ppc.Plan.create(data, opts)
  end

  @impl Ppc
  def plan_update(id, data, opts \\ []) do
    Ppc.Plan.update(id, data, opts)
  end

  @impl Ppc
  def plan_update_pricing(id, data, opts \\ []) do
    Ppc.Plan.update_pricing(id, data, opts)
  end

  # ------------------------------------ subscription --------------------------------------

  @impl Ppc
  def subscription_details(id, opts \\ []) do
    Ppc.Subscription.details(id, opts)
  end

  @impl Ppc
  def subscription_create(data, opts \\ []) do
    Ppc.Subscription.create(data, opts)
  end

  @impl Ppc
  def subscription_revise(id, reason, opts \\ []) do
    Ppc.Subscription.revise(id, reason, opts)
  end

  @impl Ppc
  def subscription_activate(id, reason, opts \\ []) do
    Ppc.Subscription.activate(id, reason, opts)
  end

  @impl Ppc
  def subscription_suspend(id, reason, opts \\ []) do
    Ppc.Subscription.suspend(id, reason, opts)
  end

  @impl Ppc
  def subscription_cancel(id, reason, opts \\ []) do
    Ppc.Subscription.cancel(id, reason, opts)
  end

  @impl Ppc
  def subscription_transactions(id, opts \\ []) do
    Ppc.Subscription.transactions(id, opts)
  end

  # ------------------------------------ webhook --------------------------------------

  @impl Ppc
  def webhook_list(opts \\ []) do
    Ppc.Webhook.list(opts)
  end

  @impl Ppc
  def webhook_details(id, opts \\ []) do
    Ppc.Webhook.details(id, opts)
  end

  @impl Ppc
  def webhook_create(data, opts \\ []) do
    Ppc.Webhook.create(data, opts)
  end

  @impl Ppc
  def webhook_delete(id, opts \\ []) do
    Ppc.Webhook.delete(id, opts)
  end

  @impl Ppc
  def webhook_update(id, data, opts \\ []) do
    Ppc.Webhook.update(id, data, opts)
  end

  @impl Ppc
  def webhook_list_event_types(id, opts \\ []) do
    Ppc.Webhook.list_event_types(id, opts)
  end

  # ------------------------------------ notification --------------------------------------

  @impl Ppc
  def notification_list(opts \\ []) do
    Ppc.Notification.list(opts)
  end

  @impl Ppc
  def notification_details(id, opts \\ []) do
    Ppc.Notification.details(id, opts)
  end

  @impl Ppc
  def notification_resend(id, id_list, opts \\ []) do
    Ppc.Notification.resend(id, id_list, opts)
  end
end
