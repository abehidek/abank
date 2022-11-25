defmodule Abank.Repo.Migrations.DeleteArticlesTable do
  use Ecto.Migration

  def change do
    drop table(:articles)
  end
end
