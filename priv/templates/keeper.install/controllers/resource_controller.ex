defmodule <%= app_module %>.<%= resource_name %>Controller do
  use <%= app_module %>.Web, :controller

  alias <%= app_module %>.<%= resource_name %>

  plug :scrub_params, "<%= String.downcase(resource_name) %>" when action in [:create]

  def create(conn, %{"<%= String.downcase(resource_name) %>" => <%= String.downcase(resource_name) %>_params}) do
    changeset = <%= resource_name %>.registration_changeset(%<%= resource_name %>{}, <%= String.downcase(resource_name) %>_params)

    case Repo.insert(changeset) do
      {:ok, <%= String.downcase(resource_name) %>} ->
        conn
        |> put_status(:created)
        |> render("show.json", <%= String.downcase(resource_name) %>: <%= String.downcase(resource_name) %>)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(<%= app_module %>.ChangesetView, "error.json", changeset: changeset)
    end
  end
end