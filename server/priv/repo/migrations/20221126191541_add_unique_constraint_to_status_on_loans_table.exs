defmodule Abank.Repo.Migrations.AddUniqueConstraintToStatusOnLoansTable do
  use Ecto.Migration

  def change do
    create index("loans", [:account_number],
             unique: true,
             where: "status = 'open' OR status = 'approved' OR status = 'late'"
           )
  end
end
