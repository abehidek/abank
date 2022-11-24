defmodule Abank.Repo.Migrations.AddCardNumberFieldInTransactionTable do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :card_number,
          references(:cards, column: :card_number, type: :string, on_delete: :nilify_all),
          null: true
    end
  end
end
