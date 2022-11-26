defmodule Abank.Repo.Migrations.AddMaxLimitToAccountsTable do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :max_limit, :integer, null: false, default: 300
    end
  end
end
