defmodule Abank.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :type,
    :card_number,
    :cvc,
    :flag,
    :expiration_date,
    :limit_in_cents,
    :invoice_due_day,
    :account_number
  ]

  @required Enum.reject(@fields, fn x -> x == :limit_in_cents or x == :invoice_due_day end)

  @derive {Jason.Encoder, only: @fields ++ [:id]}

  schema "cards" do
    field :type, :string
    field :card_number, :string
    field :cvc, :string
    field :flag, :string
    field :expiration_date, :date
    field :limit_in_cents, :integer
    field :invoice_due_day, :integer

    belongs_to :account, Abank.Accounts.Account,
      foreign_key: :account_number,
      type: :string,
      references: :number

    timestamps(updated_at: false)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@required)
    |> unique_constraint([:card_number])
    |> foreign_key_constraint(:account_number)
    |> validate_length(:card_number, is: 16)
    |> validate_length(:cvc, is: 3)
    |> validate_credit_card()
  end

  def validate_credit_card(changeset) do
    IO.inspect(changeset)
  end
end
