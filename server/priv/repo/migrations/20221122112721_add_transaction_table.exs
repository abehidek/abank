defmodule Abank.Repo.Migrations.AddTransactionTable do
  use Ecto.Migration

  def change do
    create unique_index(:accounts, [:number])

    create table(:transactions) do
      add :type, :string, null: false
      add :amount_in_cents, :integer, null: false
      add :status, :string, null: false
      add :description, :text, null: true

      add :from_account_number,
          references(:accounts, column: :number, type: :string, on_delete: :nilify_all),
          null: false

      add :to_account_number,
          references(:accounts, column: :number, type: :string, on_delete: :nilify_all),
          null: false

      timestamps(updated_at: false)
    end
  end
end
