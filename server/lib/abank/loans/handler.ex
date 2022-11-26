defmodule Abank.Loans.Handler do
  alias Abank.Loans
  alias Abank.Loans.Loan

  def verify_open_loans do
    with {:ok, [%Loan{} = _head | _rest] = open_loans} <- Loans.get_all_open_loans() do
      open_loans
      |> Enum.each(fn open_loan -> open_loan |> verify_open_loan() end)
    else
      _ -> nil
    end
  end

  def verify_open_loan(%Loan{} = open_loan) do
    # get account from loan (get_account_by_number) then use some crazy calculations based on account score and the limit, after that approves the loan with a loan_due_date
    if open_loan.amount_in_cents > 1000 do
      open_loan
      |> reject_open_loan()
    else
      open_loan
      |> approve_open_loan()
    end
  end

  defp approve_open_loan(%Loan{} = open_loan) do
    with {:ok, result} <-
           Abank.Repo.transaction(fn ->
             open_loan
             |> Ecto.Changeset.change(
               status: "approved",
               loan_due_date:
                 Timex.today()
                 |> Timex.shift(years: 1)
                 |> Timex.shift(months: Enum.random(-3..6))
                 |> Timex.shift(days: Enum.random(-30..30))
             )
             |> Abank.Repo.update!()
           end) do
      {:ok, %{result: result}}
    else
      _ -> {:error, %{result: "Something bad happened", status: 500}}
    end
  end

  defp reject_open_loan(%Loan{} = open_loan) do
    with {:ok, result} <-
           Abank.Repo.transaction(fn ->
             open_loan
             |> Ecto.Changeset.change(status: "rejected")
             |> Abank.Repo.update!()
           end) do
      {:ok, %{result: result}}
    else
      _ -> {:error, %{result: "Something bad happened", status: 500}}
    end
  end
end
