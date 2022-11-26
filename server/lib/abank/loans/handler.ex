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

  def verify_approved_loans do
    with {:ok, [%Loan{} = _head | _rest] = approved_loans} <- Loans.get_all_approved_loans() do
      approved_loans
      |> Enum.each(fn approved_loan -> approved_loan |> verify_approved_loan() end)
    else
      _ -> nil
    end
  end

  def verify_approved_loan(%Loan{} = approved_loan) do
    date_diff = Date.diff(Timex.today(), approved_loan.loan_due_date) |> IO.inspect()

    cond do
      date_diff > 0 ->
        with {:ok, result} <-
               Abank.Repo.transaction(fn ->
                 approved_loan
                 |> Ecto.Changeset.change(
                   status: "late",
                   amount_in_cents:
                     floor(approved_loan.amount_in_cents * :math.pow(1.001, date_diff))
                 )
                 |> Abank.Repo.update!()
               end) do
          {:ok, %{result: result}}
        else
          _ -> {:error, %{result: "Something bad happened", status: 500}}
        end

      date_diff > -10 ->
        # sends an notification (email or smartphone) to account informing the
        # Date.diff(Timex.today(), close_invoice.invoice_due_date) and the close_invoice.amount_in_cents
        IO.inspect(
          "You have #{date_diff} days to pay your loan of #{approved_loan.amount_in_cents}"
        )

      true ->
        nil
    end
  end

  def verify_late_loans do
    with {:ok, [%Loan{} = _head | _rest] = late_loans} <- Loans.get_all_late_loans() do
      late_loans
      |> Enum.each(fn late_loan -> late_loan |> verify_late_loan() end)
    else
      _ -> nil
    end
  end

  def verify_late_loan(%Loan{} = late_loan) do
    date_diff = Date.diff(Timex.today(), late_loan.loan_due_date) |> IO.inspect()

    with {:ok, result} <-
           Abank.Repo.transaction(fn ->
             late_loan
             |> Ecto.Changeset.change(
               amount_in_cents: floor(late_loan.amount_in_cents * :math.pow(1.001, date_diff))
             )
             |> Abank.Repo.update!()
           end) do
      {:ok, %{result: result}}
    else
      _ -> {:error, %{result: "Something bad happened", status: 500}}
    end
  end
end
