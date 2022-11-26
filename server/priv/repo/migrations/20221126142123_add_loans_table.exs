defmodule Abank.Repo.Migrations.AddLoansTable do
  use Ecto.Migration

  def change do
    create table(:loans) do
      add :amount_in_cents, :integer, null: false
      add :status, :string, null: false
      add :loan_due_date, :date, null: false

      add :account_number,
          references(:accounts, column: :number, type: :string, on_delete: :nilify_all),
          null: true

      timestamps(updated_at: false)
    end
  end
end
