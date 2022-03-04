defmodule Ppc.AccountStore do
  use GenServer

  alias Ppc.{Account}

  defstruct accounts: nil, timer: nil

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_account(name) do
    GenServer.call(__MODULE__, {:get_account, name})
  end

  # ---------- callbacks ---------------------------------------------------------------
  # ------------------------------------------------------------------------------------

  @impl true
  def init(opts) do
    accounts_collector = Keyword.fetch!(opts, :accounts)

    accounts =
      accounts_collector.()
      |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x.name, x) end)

    :timer.send_after(0, self(), :tick)

    state = %__MODULE__{accounts: accounts}
    {:ok, state}
  end

  @impl true
  def handle_call(:tick, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:get_account, name}, _from, state) do
    {:reply, state.accounts[name], state}
  end

  @impl true
  def handle_info(:tick, state) do
    updated_accounts =
      Enum.map(state.accounts, fn {_name, x} -> Account.update_token_if_needed(x) end)
      |> Enum.reduce(state.accounts, fn x, acc -> Map.put(acc, x.name, x) end)

    next_update_after = seconds_before_next_update(updated_accounts)

    :timer.send_after(next_update_after * 1000, self(), :tick)

    {:noreply, %{state | accounts: updated_accounts}}
  end

  @spec seconds_before_next_update(%{atom => Account.t()}) :: pos_integer()
  def seconds_before_next_update(account_list) do
    Enum.map(account_list, fn {_name, x} -> x.expires_at end)
    |> Enum.sort()
    |> case do
      [first | _rest] ->
        first

      _ ->
        # cooldawn 30sec.
        NaiveDateTime.add(NaiveDateTime.utc_now(), 30)
    end
    |> NaiveDateTime.diff(NaiveDateTime.utc_now())
  end
end
