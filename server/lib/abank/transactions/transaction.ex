defmodule Abank.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :type,
    :amount_in_cents,
    :status,
    :description,
    :from_account_number,
    :to_account_number
  ]

  @required Enum.reject(@fields, fn x -> x == :description end)

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

    timestamps(updated_at: false)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
