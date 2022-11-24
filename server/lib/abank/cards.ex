defmodule Abank.Cards do
  alias Abank.Cards.Card

  def create(params) do
    params
    |> Card.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  defp handle_create({:ok, %Card{}} = result), do: result
  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}
end
