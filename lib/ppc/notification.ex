defmodule Ppc.Notification do
  alias Ppc.Client

  @base_path "/v1/notifications/webhooks-events"

  @doc """
  Lists webhooks event notifications.

  Returned list is chronololically sorted in descending order.

  You can use query parameters to adjust returned list of events.

    - page_size: integer - number of events returned
    - start_time: string - only show events after or at this time
    - end_time: string - only show events before or at this time
    - transaction_id: string - get specific transaction event
    - event_type: string - show only list of specific event type.

  ## Example

      Ppc.Notifications.list(account, params: [page_size: 20])
  """
  @spec list(keyword()) :: any
  def list(opts \\ []) do
    Client.get(@base_path, opts)
  end

  @doc """
  Show details for webhook event notification.
  """
  @spec details(String.t()) :: any
  def details(id, opts \\ []) do
    Client.get("#{@base_path}/#{id}", opts)
  end

  @doc """
  Resends a webhook event notification.
  """
  @spec resend(String.t(), [String.t()]) :: any
  def resend(id, webhook_ids, opts \\ []) do
    Client.post("#{@base_path}/#{id}/resend", webhook_ids, opts)
  end
end
