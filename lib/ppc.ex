defmodule Ppc do
  @type opts :: keyword

  # ------------------------------------ supervised process ---------------------------

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {Ppc.AccountStore, :start_link, [opts]}
    }
  end

  # ------------------------------------ product ----------------------------------

  @callback product_list() :: {:ok, any} | {:error, any}
  @callback product_list(opts) :: {:ok, any} | {:error, any}

  @callback product_details(String.t()) :: {:ok, any} | {:error, any}
  @callback product_details(String.t(), opts) :: {:ok, any} | {:error, any}

  @callback product_create(map) :: {:ok, any} | {:error, any}
  @callback product_create(map, opts) :: {:ok, any} | {:error, any}

  @callback product_update(String.t(), map) :: {:ok, any} | {:error, any}
  @callback product_update(String.t(), map, opts) :: {:ok, any} | {:error, any}

  # ------------------------------------ plan ----------------------------------

  @callback plan_list() :: {:ok, any} | {:error, any}
  @callback plan_list(opts) :: {:ok, any} | {:error, any}

  @callback plan_details(String.t()) :: {:ok, any} | {:error, any}
  @callback plan_details(String.t(), opts) :: {:ok, any} | {:error, any}

  @callback plan_activate(String.t()) :: {:ok, any} | {:error, any}
  @callback plan_activate(String.t(), opts) :: {:ok, any} | {:error, any}

  @callback plan_deactivate(String.t()) :: {:ok, any} | {:error, any}
  @callback plan_deactivate(String.t(), opts) :: {:ok, any} | {:error, any}

  @callback plan_create(map) :: {:ok, any} | {:error, any}
  @callback plan_create(map, opts) :: {:ok, any} | {:error, any}

  @callback plan_update(String.t(), map) :: {:ok, any} | {:error, any}
  @callback plan_update(String.t(), map, opts) :: {:ok, any} | {:error, any}

  @callback plan_update_pricing(String.t(), map) :: {:ok, any} | {:error, any}
  @callback plan_update_pricing(String.t(), map, opts) :: {:ok, any} | {:error, any}

  # ------------------------------------ subscription ----------------------------------

  @callback subscription_details(String.t()) :: {:ok, any} | {:error, any}
  @callback subscription_details(String.t(), opts) :: {:ok, any} | {:error, any}

  @callback subscription_create(map) :: {:ok, any} | {:error, any}
  @callback subscription_create(map, opts) :: {:ok, any} | {:error, any}

  @callback subscription_revise(String.t(), String.t()) :: {:ok, any} | {:error, any}
  @callback subscription_revise(String.t(), String.t(), opts) :: {:ok, any} | {:error, any}

  @callback subscription_activate(String.t(), String.t()) :: {:ok, any} | {:error, any}
  @callback subscription_activate(String.t(), String.t(), opts) :: {:ok, any} | {:error, any}

  @callback subscription_suspend(String.t(), String.t()) :: {:ok, any} | {:error, any}
  @callback subscription_suspend(String.t(), String.t(), opts) :: {:ok, any} | {:error, any}

  @callback subscription_cancel(String.t(), String.t()) :: {:ok, any} | {:error, any}
  @callback subscription_cancel(String.t(), String.t(), opts) :: {:ok, any} | {:error, any}

  @callback subscription_transactions(String.t()) :: {:ok, any} | {:error, any}
  @callback subscription_transactions(String.t(), opts) :: {:ok, any} | {:error, any}

  # ------------------------------------ webhook ----------------------------------

  @callback webhook_list() :: {:ok, any} | {:error, any}
  @callback webhook_list(opts) :: {:ok, any} | {:error, any}

  @callback webhook_details(String.t()) :: {:ok, any} | {:error, any}
  @callback webhook_details(String.t(), opts) :: {:ok, any} | {:error, any}

  @callback webhook_create(map) :: {:ok, any} | {:error, any}
  @callback webhook_create(map, opts) :: {:ok, any} | {:error, any}

  @callback webhook_delete(String.t()) :: {:ok, any} | {:error, any}
  @callback webhook_delete(String.t(), opts) :: {:ok, any} | {:error, any}

  @callback webhook_update(String.t(), map) :: {:ok, any} | {:error, any}
  @callback webhook_update(String.t(), map, opts) :: {:ok, any} | {:error, any}

  @callback webhook_list_event_types(String.t()) :: {:ok, any} | {:error, any}
  @callback webhook_list_event_types(String.t(), opts) :: {:ok, any} | {:error, any}

  # ------------------------------------ notification ----------------------------------

  @callback notification_list() :: {:ok, any} | {:error, any}
  @callback notification_list(opts) :: {:ok, any} | {:error, any}

  @callback notification_details(String.t()) :: {:ok, any} | {:error, any}
  @callback notification_details(String.t(), opts) :: {:ok, any} | {:error, any}

  @callback notification_resend(String.t(), [String.t()]) :: {:ok, any} | {:error, any}
  @callback notification_resend(String.t(), [String.t()], opts) :: {:ok, any} | {:error, any}

  # ------------------------------------ notification ----------------------------------

  def product_list(opts \\ []), do: impl().product_list(opts)
  def product_details(id, opts \\ []), do: impl().product_details(id, opts)
  def product_create(map, opts \\ []), do: impl().product_create(map, opts)
  def product_update(id, map, opts \\ []), do: impl().product_update(id, map, opts)

  def plan_list(opts \\ []), do: impl().plan_list(opts)
  def plan_details(id, opts \\ []), do: impl().plan_details(id, opts)
  def plan_activate(id, opts \\ []), do: impl().plan_activate(id, opts)
  def plan_deactivate(id, opts \\ []), do: impl().plan_deactivate(id, opts)
  def plan_create(map, opts \\ []), do: impl().plan_create(map, opts)
  def plan_update(id, map, opts \\ []), do: impl().plan_update(id, map, opts)
  def plan_update_pricing(id, map, opts \\ []), do: impl().plan_update_pricing(id, map, opts)

  def subscription_details(id, opts \\ []), do: impl().subscription_details(id, opts)
  def subscription_create(map, opts \\ []), do: impl().subscription_create(map, opts)

  def subscription_revise(id, reason, opts \\ []),
    do: impl().subscription_revise(id, reason, opts)

  def subscription_activate(id, reason, opts \\ []),
    do: impl().subscription_activate(id, reason, opts)

  def subscription_suspend(id, reason, opts \\ []),
    do: impl().subscription_suspend(id, reason, opts)

  def subscription_cancel(id, reason, opts \\ []),
    do: impl().subscription_cancel(id, reason, opts)

  def subscription_transactions(id, opts \\ []), do: impl().subscription_transactions(id, opts)

  def webhook_list(opts \\ []), do: impl().webhook_list(opts)
  def webhook_details(id, opts \\ []), do: impl().webhook_details(id, opts)
  def webhook_create(map, opts \\ []), do: impl().webhook_create(map, opts)
  def webhook_delete(id, opts \\ []), do: impl().webhook_delete(id, opts)
  def webhook_update(id, map, opts \\ []), do: impl().webhook_update(id, map, opts)
  def webhook_list_event_types(id, opts \\ []), do: impl().webhook_list_event_types(id, opts)

  def notification_list(opts \\ []), do: impl().notification_list(opts)
  def notification_details(id, opts \\ []), do: impl().notification_details(id, opts)

  def notification_resend(id, id_list, opts \\ []),
    do: impl().notification_resend(id, id_list, opts)

  defp impl, do: Application.get_env(:ppc, :ppc, Ppc.Live)
end
