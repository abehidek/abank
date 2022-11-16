defmodule Abank.Repo.Migrations.CreateArticlesTable do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :content, :string, null: false
      add :draft, :boolean, null: false
      add :author, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:articles, [:author])
  end
end
