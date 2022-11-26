defmodule Abank.Loans.Loan do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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
    # possible status:
    # "open" -> loan request made by account
    # "approved" -> loan request approved by bank
    # "rejected" -> loan request rejected by bank
    # "payed" -> loan already payed by account
    # "late" -> loan not payed by account, each day the amount increase significantly
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

    # validate one loan per status: "approved", "open" or "late"
  end

  def get_approved_or_late_loan_by_account_number_query(account_number)
      when is_binary(account_number) do
    query =
      from loan in __MODULE__,
        where:
          loan.account_number == ^account_number and
            (loan.status == "approved" or
               loan.status == "late")

    {:ok, query}
  end

  def get_all_open_loans_query do
    query =
      from loan in __MODULE__,
        where: loan.status == "open"

    {:ok, query}
  end

  def get_all_approved_loans_query do
    query =
      from loan in __MODULE__,
        where: loan.status == "approved"

    {:ok, query}
  end

  def get_all_late_loans_query do
    query =
      from loan in __MODULE__,
        where: loan.status == "late"

    {:ok, query}
  end
end
