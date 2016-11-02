defmodule Keeper do
  @moduledoc """
  Keeper is a flexible and out of the box authentication solution for Phoenix.
  The main goal is to provide a simple-to-use solution based on conventions, while
  still keeping the ability to easily customize it.
  It offers a set of customizations and setups available through the installation
  mix task.

  Check [README](readme.html) file for overall information.

  ## Mix Tasks
  ### Installer
      $ mix keeper.install

  Run `$ mix help keeper.install` for more information.
  """
  use Application

  @doc false
  def start(_type, _args) do
    Keeper.Supervisor.start_link()
  end
end
