defmodule <%= app_module %>.<%= resource_name %> do
  use <%= app_module %>.Web, :model

  schema "<%= plural_resource_name %>" do
    field :email, :string
    field :password_hash, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
  end
end
