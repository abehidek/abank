defmodule Abank.Repo.Migrations.AlterCvcFieldInCardsTable do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      modify :cvc, :string, null: false
    end
  end
end
