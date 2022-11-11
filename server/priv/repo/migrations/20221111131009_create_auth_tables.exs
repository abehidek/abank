defmodule Abank.Repo.Migrations.CreateAuthTables do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime

      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_session) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false

      timestamps(updated_at: false)
    end

    create index(:users_session, [:user_id])
    create unique_index(:users_session, [:token])

    create table(:users_confirm) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :sent_to, :string

      timestamps(updated_at: false)
    end

    create index(:users_confirm, [:user_id])
    create unique_index(:users_confirm, [:token])
  end
end
