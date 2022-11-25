# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Abank.Repo.insert!(%Abank.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Creating users

alias Abank.Auth
alias Abank.Accounts

alias Abank.Auth.User
alias Abank.Accounts.Account

Abank.Repo.delete_all(User)
Abank.Repo.delete_all(Account)

{:ok, %User{} = john_doe_user} =
  %{
    "email" => "john@doe.com",
    "password" => "johndoe1234567",
    "address" => "St John Doe 777",
    "cpf" => "123.456.789-10"
  }
  |> Auth.register_user()

{:ok, %User{} = abe_hidek_user} =
  %{
    "email" => "abe@hidek.com",
    "password" => "johndoe1234567",
    "address" => "St John Doe 777",
    "cpf" => "123.456.789-10"
  }
  |> Auth.register_user()

# Creating accounts for each user

{:ok, %Account{} = john_doe_account} =
  %{"number" => "80962955"}
  |> Map.put("user_id", john_doe_user.id)
  |> Accounts.create()

{:ok, %Account{} = abe_hidek_account} =
  %{"number" => "58232255"}
  |> Map.put("user_id", abe_hidek_user.id)
  |> Accounts.create()
