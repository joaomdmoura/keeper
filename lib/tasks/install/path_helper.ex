defmodule Mix.Tasks.Keeper.Install.PathHelper do

  @test_paths %{
    keeper_path: ".",
    model_path: "test/support/models",
    migrations_path: "test/support/migrations",
    templates_path: "priv/templates/keeper.install"
  }

  @prod_paths %{
    keeper_path: nil,
    model_path: "web/models",
    migrations_path: "priv/repo/migrations",
    templates_path: "priv/templates/keeper.install"
  }

  @moduledoc false

  @doc false
  def keeper_path do
    case env_path_value(:keeper_path) do
      # Workaround to make sure it will find the dependincy path
      nil -> Mix.Project.deps_paths[:keeper]
      not_nil -> not_nil
    end
  end

  @doc false
  def migrations_path, do: env_path_value(:migrations_path)

  @doc false
  def model_path, do: env_path_value(:model_path)

  @doc false
  def templates_path, do: env_path_value(:templates_path)

  defp env_path_value(key), do: if Mix.env != :test, do: @prod_paths[key], else: @test_paths[key]
end
