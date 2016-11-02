defmodule Mix.Tasks.Keeper.Install do
  @moduledoc """
  Installs Keeper, check for the resource that will be used Phoenix application.

  The installation task will follow:
  * Add :keeper configuration to `config/config.exs`.
  * Generate migration files.
  * Generate view files.
  * Generate template files.
  * Generate a `web/models/user.ex` file if one does not already exist.
  """

  use Mix.Task

  @shortdoc "Installs the Keeper Package"

  def run(args) do
  end
end
