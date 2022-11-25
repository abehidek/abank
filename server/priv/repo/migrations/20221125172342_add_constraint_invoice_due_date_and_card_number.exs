defmodule Abank.Repo.Migrations.AddConstraintInvoiceDueDateAndCardNumber do
  use Ecto.Migration

  def change do
    create unique_index(:invoices, [:invoice_due_date, :card_number])
  end
end
