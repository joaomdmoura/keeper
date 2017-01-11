defmodule Mix.Tasks.Keeper.Install.PathHelper do

  @test_paths %{
    keeper_path: ".",
    router_path: "test/support/web",
    model_path: "test/support/models",
    migrations_path: "test/support/migrations",
    controllers_path: "test/support/controllers",
    templates_path: "priv/templates/keeper.install"
  }

  @prod_paths %{
    keeper_path: nil,
    router_path: "web",
    model_path: "web/models",
    migrations_path: "priv/repo/migrations",
    controllers_path: "web/controllers",
    templates_path: "priv/templates/keeper.install"
  }

  @moduledoc false

  @doc false
  def keeper_path do
    case env_path(:keeper_path) do
      # Workaround to make sure it will find the dependincy path
      nil -> Mix.Project.deps_paths[:keeper]
      not_nil -> not_nil
    end
  end

  @doc false
  def env_path(key) do
    if Mix.env != :test, do: @prod_paths[key], else: @test_paths[key]
  end
end
