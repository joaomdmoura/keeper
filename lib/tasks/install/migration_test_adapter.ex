defmodule Mix.Tasks.Keeper.Install.MigrationTestAdapter do
  use Mix.Task
  @moduledoc false

  @doc false
  def run(_args) do
    Mix.Phoenix.copy_from [".", :keeper],
    "test/support/migrations", "", [],
    [{:eex, "/fake_migration.exs", "test/support/migrations/000_create_users.exs"}]
  end
end
