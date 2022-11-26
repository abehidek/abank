defmodule Abank.Loans do
  alias Abank.Loans.Loan
  alias Abank.Accounts

  def create(params) do
    params
    |> Map.put("status", "open")
    |> Map.delete("loan_due_date")
    # |> Map.put( Loan due date should be put when loan is accepted
    #   "loan_due_date",
    #   Timex.today()
    #   |> Timex.shift(years: 1)
    #   |> Timex.shift(months: Enum.random(-3..6))
    #   |> Timex.shift(days: Enum.random(-30..30))
    # )
    |> Loan.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  def new(params, user) do
    with {:ok, account} <- Accounts.get_account_by_user(user) do
      params
      |> Map.put("account_number", account.number)
      |> create()
    end
  end

  defp handle_create({:ok, %Loan{}} = result), do: result
  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}
end
