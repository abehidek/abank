defmodule Abank.Repo.Migrations.CreateCardsTable do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :type,            :string,  null: false
      add :card_number,     :string,  null: false
      add :cvc,             :integer, null: false
      add :flag,            :string,  null: false
      add :expiration_date, :date,    null: false
      add :limit_in_cents,  :integer, null: true
      add :invoice_due_day, :integer, null: true

      add :account_number,
          references(:accounts, column: :number, type: :string, on_delete: :delete_all),
          null: false

      timestamps(updated_at: false)
    end

    create unique_index(:cards, [:card_number])
  end
end
