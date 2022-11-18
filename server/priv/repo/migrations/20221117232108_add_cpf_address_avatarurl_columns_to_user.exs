defmodule Abank.Repo.Migrations.AddCpfAddressAvatarurlColumnsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :cpf, :string, null: false
      add :address, :string, null: false
      add :avatar_url, :string, null: true
    end
  end
end
