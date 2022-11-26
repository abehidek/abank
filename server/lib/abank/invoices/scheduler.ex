defmodule Abank.Invoices.Scheduler do
  use GenServer

  alias Abank.Invoices.Handler
  alias Abank.Cards.Card

  # --- Client

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def verify_credit_card_invoice_status(credit_card) do
    GenServer.call(__MODULE__, {:verify_credit_card_invoices_status, credit_card})
  end

  def verify_credit_card_invoice_payment(credit_card) do
    GenServer.call(__MODULE__, {:verify_credit_card_invoices_payment, credit_card})
  end

  # --- Server

  @impl true
  def init(state \\ %{}) do
    schedule_invoices_routine()
    {:ok, state}
  end

  @impl true
  def handle_info(:verify_all_invoices, state) do
    Handler.verify_invoices_status()
    Handler.verify_invoices_payment()

    schedule_invoices_routine()
    {:noreply, state}
  end

  @impl true
  def handle_call({:verify_credit_card_invoices_status, %Card{} = credit_card}, _from, state) do
    result = Handler.verify_credit_card_invoices_status(credit_card)
    {:reply, result, state}
  end

  @impl true
  def handle_call({:verify_credit_card_invoices_payment, %Card{} = credit_card}, _from, state) do
    result = Handler.verify_credit_card_invoices_payment(credit_card)
    {:reply, result, state}
  end

  def schedule_invoices_routine do
    Process.send_after(
      self(),
      :verify_all_invoices,
      # 1 hour
      1000 * 60 * 60
      # 1000 * 30
      # * 6 # 6 hours total
    )
  end
end
