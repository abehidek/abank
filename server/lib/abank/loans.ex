defmodule Abank.Loans do
  alias Abank.Transactions
  alias Abank.Loans.{Loan, Scheduler}
  alias Abank.Accounts

  def get_one(user) do
    with {:ok, account} <- Accounts.get_account_by_user(user) do
      # |> Map.put("account_number", account.number)
      get_approved_or_late_loan(account.number)
    end
  end

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

  defp handle_create({:ok, %Loan{} = loan} = _result) do
    Scheduler.run_open_loan(loan)
  end

  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}

  def get_approved_or_late_loan(account_number) do
    {:ok, query} = Loan.get_approved_or_late_loan_by_account_number_query(account_number)

    approved_or_late_loan =
      query
      |> Abank.Repo.one()

    if approved_or_late_loan do
      {:ok, approved_or_late_loan}
    else
      {:error, %{result: "No loan found to pay", status: 404}}
    end
  end

  def pay_loan(%{"account_number" => account_number}) do
    with {:ok, %Loan{} = approved_or_late_loan} <- account_number |> get_approved_or_late_loan() do
      %{
        "amount_in_cents" => approved_or_late_loan.amount_in_cents,
        "to_account_number" => nil,
        "from_account_number" => account_number,
        "type" => "loan_payment",
        "status" => "open",
        "description" => "Loan id:#{approved_or_late_loan.id} payment"
      }
      |> Transactions.create_to_bank_transaction()
    else
      {:error, %{result: result, status: status}} -> {:error, %{result: result, status: status}}
      _ -> {:error, %{result: "Something bad happened", status: 500}}
    end
  end

  def pay_loan(params, user) do
    with {:ok, account} <- Accounts.get_account_by_user(user) do
      params
      |> Map.put("account_number", account.number)
      |> pay_loan()
    end
  end

  def get_all_open_loans do
    {:ok, query} = Loan.get_all_open_loans_query()

    open_loans = query |> Abank.Repo.all()

    if open_loans do
      {:ok, open_loans}
    else
      {:error, %{result: "No open loans found", status: 404}}
    end
  end

  def get_all_approved_loans do
    {:ok, query} = Loan.get_all_approved_loans_query()

    approved_loans = query |> Abank.Repo.all()

    if approved_loans do
      {:ok, approved_loans}
    else
      {:error, %{result: "No approved loans found", status: 404}}
    end
  end

  def get_all_late_loans do
    {:ok, query} = Loan.get_all_late_loans_query()

    late_loans = query |> Abank.Repo.all()

    if late_loans do
      {:ok, late_loans}
    else
      {:error, %{result: "No late loans found", status: 404}}
    end
  end
end
