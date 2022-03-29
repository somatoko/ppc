defmodule Ppc.Webhook do
  alias Ppc.Client

  @base_path "/v1/notifications/webhooks"

  @doc """
  List all webhooks for current app.
  """
  @spec list(keyword()) :: any
  def list(opts \\ []) do
    Client.get(@base_path, opts)
  end

  @doc """
  Show webhook details.
  """
  @spec details(String.t()) :: any
  def details(id, opts \\ []) do
    Client.get("#{@base_path}/#{id}", opts)
  end

  @doc """
  Create a new webhook.

  Accepted fields:
  - url: string (required) - endpoint url that will listen to events.
  - event_types: object[] (required) - supported events; you may use '*' to subscribe to all events.
  """
  @spec create(map, keyword) :: {:ok, any} | {:error, any}
  def create(map, opts) do
    Client.post(@base_path, map, opts)
  end

  @doc """
  Delete a webhook.
  """
  @spec delete(String.t(), keyword) :: {:ok, any} | {:error, any}
  def delete(id, opts) do
    Client.delete("#{@base_path}/#{id}", opts)
  end

  @doc """
  Update a webhook.

  Can only update following fields:
  - url: string
  - event_types: object[]
  """
  @spec update(String.t(), map, keyword) :: {:ok, any} | {:error, any}
  def update(id, updates, opts) do
    {:ok, prev} = details(id, keys: :strings)

    changes = extract_changes(prev, updates)
    Client.patch("#{@base_path}/#{id}", changes, opts)
  end

  @doc """
  Return a list of subscribed event types for particular hook.
  """
  @spec list_event_types(String.t(), keyword) :: {:ok, any} | {:error, any}
  def list_event_types(id, opts) do
    Client.get("#{@base_path}/#{id}/event-types", opts)
  end

  @doc """
  Construct operations list for updating webhook entry.
  """
  @spec extract_changes(map, map) :: [map]
  def extract_changes(prev, params) do
    changes = []

    changes =
      if params["url"] && prev["url"] != params["url"] do
        [%{"op" => "replace", "path" => "/url", "value" => params["url"]} | changes]
      else
        changes
      end

    events_prev =
      prev["event_types"]
      |> Enum.map(fn x -> x["name"] end)
      |> MapSet.new()

    events_next =
      Map.get(params, "event_types", prev["event_types"])
      |> Enum.map(fn x -> x["name"] end)
      |> MapSet.new()

    changes =
      cond do
        # Test items got removed or added
        MapSet.difference(events_prev, events_next) |> MapSet.size() > 0 ||
            MapSet.difference(events_next, events_prev) |> MapSet.size() > 0 ->
          events = Enum.map(params["event_types"], fn x -> Map.take(x, ["name"]) end)

          [
            %{"op" => "replace", "path" => "/event_types", "value" => events}
            | changes
          ]

        true ->
          changes
      end

    changes
  end
end
