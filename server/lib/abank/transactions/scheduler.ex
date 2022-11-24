defmodule Abank.Transactions.Scheduler do
  use GenServer

  alias Abank.Transactions.Handler

  # --- Client

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def run_transaction(transaction) do
    GenServer.call(__MODULE__, {:run_one, transaction})
  end

  # --- Server

  @impl true
  def init(state \\ %{}) do
    schedule_transactions_routine()
    {:ok, state}
  end

  @impl true
  def handle_info(:run_all, state) do
    Handler.run_all_transactions()

    schedule_transactions_routine()
    {:noreply, state}
  end

  @impl true
  def handle_call({:run_one, transaction}, _from, state) do
    result = Handler.run_transaction(transaction)

    schedule_transactions_routine()
    {:reply, result, state}
  end

  def schedule_transactions_routine do
    Process.send_after(self(), :run_all, 1000 * 60 * 60)
  end
end
