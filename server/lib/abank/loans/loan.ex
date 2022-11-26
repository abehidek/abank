defmodule Abank.Loans.Loan do
  use Ecto.Schema
  import Ecto.Changeset
  # import Ecto.Query

  @fields [
    :amount_in_cents,
    :status,
    :loan_due_date,
    :account_number
  ]

  @required Enum.reject(@fields, fn x -> x == :loan_due_date end)

  @derive {Jason.Encoder, only: @fields ++ [:id, :inserted_at]}

  schema "loans" do
    field :amount_in_cents, :integer
    field :status, :string
    field :loan_due_date, :date

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
    |> foreign_key_constraint(:account_number)
  end
end
