defmodule Abank.Invoices.Handler do
  alias Abank.Invoices
  alias Abank.Invoices.Invoice
  alias Abank.Cards
  alias Abank.Cards.Card

  use Timex

  def verify_invoices_payment do
    {:ok, query} = Card.get_credit_cards()

    credit_cards =
      query
      |> Abank.Repo.all()

    if credit_cards do
      credit_cards
      |> Enum.each(fn credit_card ->
        credit_card
        |> verify_invoice_payment()
      end)
    end
  end

  defp verify_invoice_payment(credit_card) do
    {:ok, query} = Invoice.get_close_invoices_by_credit_card(credit_card)

    close_invoices =
      query
      |> Abank.Repo.all()
      |> IO.inspect()

    close_invoices
    |> Enum.each(fn close_invoice ->
      close_invoice
      |> verify_payment()
    end)
  end

  defp verify_payment(%Invoice{} = close_invoice) do
    if close_invoice.amount_in_cents > 0 and
         Date.diff(Timex.today(), close_invoice.invoice_due_date) > 0 do
      {:ok, query} = Invoice.get_open_invoice()

      open_invoice =
        query
        |> Abank.Repo.one()
        |> IO.inspect(
          label:
            "Getting open invoice to update the amount value that is equal to the closed invoice + interest rates"
        )

      if open_invoice do
        with {:ok, _} <-
               Abank.Repo.transaction(fn ->
                 Ecto.Changeset.change(open_invoice,
                   amount_in_cents:
                     floor(open_invoice.amount_in_cents + close_invoice.amount_in_cents * 1.10)
                 )
                 |> Abank.Repo.update!()

                 Ecto.Changeset.change(close_invoice,
                   amount_in_cents: 0
                 )
                 |> Abank.Repo.update!()

                 # also needs to lower the account score because the user has not payed it's own closed invoice
               end) do
          {:ok, open_invoice}
        end
      else
        {:error, %{result: "No open invoices to update"}}
      end
    else
      if(close_invoice.amount_in_cents > 0) do
        # credit_card = Cards. get credit_card by invoice
        # account = Accounts. get account by credit card
        # IO.inspect("The account #{}")
        # sends an notification (email or smartphone) to account informing the
        # Date.diff(Timex.today(), close_invoice.invoice_due_date) and the close_invoice.amount_in_cents
      end

      {:ok, close_invoice}
    end
  end

  def verify_invoices_status do
    {:ok, query} = Card.get_credit_cards()

    credit_cards =
      query
      |> Abank.Repo.all()

    if credit_cards do
      credit_cards
      |> Enum.each(fn credit_card ->
        credit_card
        |> create_invoice_if_not_exists()
        |> verify_invoice_status()
      end)
    end
  end

  defp create_invoice_if_not_exists(credit_card) do
    {:ok, query} = Invoice.get_open_invoice_by_credit_card(credit_card)

    open_invoice =
      query
      |> Abank.Repo.one()
      |> IO.inspect()

    if open_invoice do
      {:ok, open_invoice}
    else
      %{
        "amount_in_cents" => 0,
        "status" => "open",
        "invoice_due_date" =>
          Timex.today()
          |> Timex.set(day: credit_card.invoice_due_day)
          |> Timex.shift(months: 1),
        "card_number" => credit_card.card_number
      }
      |> Invoices.create()
      |> IO.inspect(label: "New invoice created because it didn't exist")
    end
  end

  defp verify_invoice_status({:ok, %Invoice{} = invoice}) do
    invoice_close_date =
      invoice.invoice_due_date
      |> Timex.shift(days: -10)

    if Timex.today() > invoice_close_date do
      with {:ok, _} <-
             Abank.Repo.transaction(fn ->
               Ecto.Changeset.change(invoice,
                 status: "close"
               )
               |> Abank.Repo.update!()
             end) do
        %{
          "amount_in_cents" => 0,
          "status" => "open",
          "invoice_due_date" =>
            invoice.invoice_due_date
            |> Timex.shift(months: 1),
          "card_number" => invoice.card_number
        }
        |> Invoices.create()
        |> IO.inspect(label: "New invoice created because previous invoice already closed")
      end
    end
  end
end
