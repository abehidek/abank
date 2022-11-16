defmodule Abank.Articles do
  alias Abank.Articles.{Article}

  def all() do
    Abank.Repo.all(Article)
  end

  def create(params) do
    params
    |> Article.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  defp handle_create({:ok, %Article{}} = result), do: result

  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}
end
