defmodule Abank.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @fields [
    :type,
    :amount_in_cents,
    :status,
    :description,
    :from_account_number,
    :to_account_number,
    :card_number
  ]

  @required Enum.reject(@fields, fn x -> x == :description or x == :card_number end)

  @derive {Jason.Encoder, only: @fields ++ [:id]}

  schema "transactions" do
    field :type, :string
    field :amount_in_cents, :integer
    field :status, :string
    field :description, :string

    belongs_to :from_account, Abank.Accounts.Account,
      foreign_key: :from_account_number,
      type: :string,
      references: :number

    belongs_to :to_account, Abank.Accounts.Account,
      foreign_key: :to_account_number,
      type: :string,
      references: :number

    belongs_to :card, Abank.Cards.Card,
      foreign_key: :card_number,
      type: :string,
      references: :card_number

    timestamps(updated_at: false)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@required)
    |> validate_card?(params)
  end

  defp validate_card?(changeset, %{"type" => type}) do
    if type == "credit" or type == "debit" do
      changeset
      |> validate_required([:card_number])
      |> foreign_key_constraint(:card_number)
    else
      changeset
    end
  end

  def get_open_transactions do
    query =
      from transaction in __MODULE__,
        where: transaction.status == "open"

    {:ok, query}
  end
end
