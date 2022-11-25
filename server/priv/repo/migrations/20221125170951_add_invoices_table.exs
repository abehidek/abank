defmodule Abank.Repo.Migrations.AddInvoicesTable do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :amount_in_cents, :integer, null: false
      add :status, :string, null: false
      add :invoice_due_date, :date, null: false

      add :card_number,
          references(:cards, column: :card_number, type: :string, on_delete: :nilify_all),
          null: true

      timestamps()
    end
  end
end
