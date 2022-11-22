defmodule Abank.Repo.Migrations.AddAccountTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :number, :string, null: false
      add :balance_in_cents, :integer, null: false, default: 0
      add :score, :integer, null: false, default: 50
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
