defmodule Abank.Loans do
  alias Abank.Loans.Loan
  alias Abank.Accounts

  def create(params) do
    params
    |> Map.put("status", "open")
    |> Map.delete("loan_due_date")
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

  def get_all_open_loans do
    {:ok, query} = Loan.get_all_open_loans_query()

    open_loans = query |> Abank.Repo.all()

    if open_loans do
      {:ok, open_loans}
    else
      {:error, %{result: "No open loans found", status: 404}}
    end
  end
end
