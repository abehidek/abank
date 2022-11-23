defmodule Abank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @fields [:number, :balance_in_cents, :score, :user_id]

  @derive {Jason.Encoder, only: @fields ++ [:id]}

  schema "accounts" do
    field :number, :string
    field :balance_in_cents, :integer, default: 0
    field :score, :integer, default: 50

    belongs_to :user, Abank.Auth.User, foreign_key: :user_id, references: :id

    has_many :from_transactions, Abank.Transactions.Transaction,
      foreign_key: :from_account_number,
      references: :number

    has_many :to_transactions, Abank.Transactions.Transaction,
      foreign_key: :to_account_number,
      references: :number

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required([:number, :user_id])
    |> unique_constraint([:user_id])
    |> unique_constraint([:number])
  end

  def get_account_by_user(user) do
    query =
      from account in __MODULE__,
        where: [user_id: ^user.id],
        select: account

    {:ok, query}
  end

  def get_account_by_number(number) do
    query =
      from account in __MODULE__,
        where: [number: ^number],
        select: account

    {:ok, query}
  end
end
