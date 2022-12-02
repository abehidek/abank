defmodule Abank.Loans.Scheduler do
  use GenServer

  alias Abank.Loans.Handler

  # --- Client

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def run_open_loan(loan) do
    GenServer.call(__MODULE__, {:run_one_open, loan})
  end

  # --- Server

  @impl true
  def init(state \\ %{}) do
    schedule_transactions_routine()
    {:ok, state}
  end

  @impl true
  def handle_info(:run_all, state) do
    Handler.verify_approved_loans()
    Handler.verify_late_loans()
    Handler.verify_open_loans()
    schedule_transactions_routine()
    {:noreply, state}
  end

  @impl true
  def handle_call({:run_one_open, loan}, _from, state) do
    result = Handler.verify_open_loan(loan)
    {:reply, result, state}
  end

  def schedule_transactions_routine do
    Process.send_after(
      self(),
      :run_all,
      1000 * 60 * 60
      # 1000 * 10
    )
  end
end
