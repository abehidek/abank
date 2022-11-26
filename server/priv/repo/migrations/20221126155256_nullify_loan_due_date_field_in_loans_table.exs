defmodule Abank.Repo.Migrations.NullifyLoanDueDateFieldInLoansTable do
  use Ecto.Migration

  def change do
    alter table(:loans) do
      modify :loan_due_date, :date, null: true
    end
  end
end
