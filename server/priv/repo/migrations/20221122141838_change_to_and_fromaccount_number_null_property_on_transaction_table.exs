defmodule Abank.Repo.Migrations.ChangeToAndFromaccountNumberNullPropertyOnTransactionTable do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      modify :from_account_number, :string, null: true

      modify :to_account_number, :string, null: true
    end
  end
end
