defmodule Abank.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Abank.Cards.Card

  @fields [
    :amount_in_cents,
    :status,
    :invoice_due_date,
    :card_number
  ]

  @required @fields

  @derive {Jason.Encoder, only: @fields ++ [:id]}

  schema "invoices" do
    field :amount_in_cents, :integer
    field :status, :string
    field :invoice_due_date, :date

    belongs_to :card, Abank.Cards.Card,
      foreign_key: :card_number,
      type: :string,
      references: :card_number

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@required)
    |> unique_constraint([:invoice_due_date, :card_number])
    |> foreign_key_constraint(:card_number)
  end

  def get_open_invoice do
    query =
      from invoice in __MODULE__,
        where: invoice.status == "open"

    {:ok, query}
  end

  def get_close_invoices do
    query =
      from invoice in __MODULE__,
        where: invoice.status == "close"

    {:ok, query}
  end

  def get_close_invoices_by_credit_card(%Card{type: "credit"} = card) do
    query =
      from invoice in __MODULE__,
        where: invoice.card_number == ^card.card_number and invoice.status == "close"

    {:ok, query}
  end

  def get_open_invoice_by_credit_card(%Card{type: "credit"} = card) do
    query =
      from invoice in __MODULE__,
        where: invoice.card_number == ^card.card_number and invoice.status == "open"

    {:ok, query}
  end
end
