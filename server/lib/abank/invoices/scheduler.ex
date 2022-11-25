defmodule Abank.Invoices.Scheduler do
  use GenServer

  alias Abank.Invoices.Handler

  # --- Client

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # --- Server

  @impl true
  def init(state \\ %{}) do
    schedule_invoices_routine()
    {:ok, state}
  end

  @impl true
  def handle_info(:run_all, state) do
    Handler.verify_invoices_status()
    Handler.verify_invoices_payment()

    schedule_invoices_routine()
    {:noreply, state}
  end

  def schedule_invoices_routine do
    Process.send_after(
      self(),
      :run_all,
      # 1 hour
      1000 * 60 * 60
      # * 6 # 6 hours total
    )
  end
end
