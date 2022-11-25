defmodule Abank.Invoices do
  alias Abank.Invoices.Invoice

  def create(params) do
    params
    |> Invoice.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  defp handle_create({:ok, %Invoice{}} = result), do: result
  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}
end
