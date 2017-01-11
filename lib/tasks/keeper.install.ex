defmodule Mix.Tasks.Keeper.Install do
  use Mix.Task
  alias Mix.Tasks.Keeper.Install.{PathHelper, MigrationTestAdapter}

  @shortdoc "Installs the Keeper to the Phoenix Application"

  @model_path PathHelper.env_path(:model_path)
  @views_path PathHelper.env_path(:views_path)
  @router_path PathHelper.env_path(:router_path)
  @templates_path PathHelper.env_path(:templates_path)
  @migrations_path PathHelper.env_path(:migrations_path)
  @controllers_path PathHelper.env_path(:controllers_path)
  @migration_module if Mix.env != :test, do: Mix.Tasks.Ecto.Gen.Migration, else: MigrationTestAdapter

  @moduledoc """
  Installs Keeper for a specific Phoenix resource.

      mix keeper.install User users

  The first argument is the module name followed by its plural
  name.

  The installation task will follow:

    * Add :keeper configuration to `config/config.exs`.
    * Create the resource.
    * Generate migrations.
    * Add new routes.
    * Generate controller.
    * Generate view.
  """

  @doc """
  Main method for the install task, it call other private methods that handle
  the files generation and setup
  """
  def run(args) do
    {_, parsed, _} = OptionParser.parse(args)

    parsed
    |> validate_args!
    |> append_app_name
    |> generate_model
    |> generate_migration
    |> add_routes
    |> generate_controller
    |> generate_view

    print_instructions
  end

  defp generate_model([resource_name, plural_resource_name, app_module] = args) do
    unless module_exists?(resource_name) do
      fname = resource_name |> String.downcase |> Phoenix.Naming.underscore
      opts = [
        resource_name: resource_name,
        plural_resource_name: plural_resource_name,
        app_module: app_module
      ]

      Mix.Phoenix.copy_from [".", :keeper],
      "#{@templates_path}/models", "", opts,
      [{:eex, "resource.ex", "#{@model_path}/#{fname}.ex"}]
    end
    args
  end

  defp generate_migration([_resource_name, plural_resource_name | _] = args) do
    migration_name = "create_#{plural_resource_name}"
    @migration_module.run [migration_name]

    fname = File.ls!(@migrations_path)
    |> Enum.find(fn(name) -> name =~ ~r/[0-9]+\_#{migration_name}/ end)

    fpath = Path.join(@migrations_path, fname)
    content = File.read!(fpath)

    template = "#{PathHelper.keeper_path}/#{@templates_path}"
    |> Path.join("migrations/create_resource.exs")
    |> File.read!

    new_content = Regex.replace(~r/  def change do\n{2} .+end/, content, template)
    File.write!(fpath, new_content)
    args
  end

  defp add_routes([resource_name, plural_resource_name, app_module] = args) do
    fpath = Path.join(@router_path, "router.ex")
    content = File.read!(fpath)

    opts = [
      resource_name: resource_name,
      plural_resource_name: plural_resource_name,
      app_module: app_module
    ]

    template = "#{PathHelper.keeper_path}/#{@templates_path}"
    |> Path.join("router.ex")
    |> EEx.eval_file(opts)

    new_content = Regex.replace(~r/scope "\/", #{app_module} do/, content, template)
    File.write!(fpath, new_content)
    args
  end

  defp generate_controller([resource_name, plural_resource_name, app_module] = args) do
    unless module_exists?("#{resource_name}Controller") do
      rname = resource_name |> String.downcase |> Phoenix.Naming.underscore
      fname = "#{rname}_controller"
      opts = [
        resource_name: resource_name,
        plural_resource_name: plural_resource_name,
        app_module: app_module
      ]

      Mix.Phoenix.copy_from [".", :keeper],
      "#{@templates_path}/controllers", "", opts,
      [{:eex, "resource_controller.ex", "#{@controllers_path}/#{fname}.ex"}]
    end
    args
  end

  def generate_view([resource_name, plural_resource_name, app_module] = args) do
    unless module_exists?("#{resource_name}View") do
      rname = resource_name |> String.downcase |> Phoenix.Naming.underscore
      fname = "#{rname}_view"
      opts = [
        resource_name: resource_name,
        plural_resource_name: plural_resource_name,
        app_module: app_module
      ]

      Mix.Phoenix.copy_from [".", :keeper],
      "#{@templates_path}/views", "", opts,
      [{:eex, "resource_view.ex", "#{@views_path}/#{fname}.ex"}]
    end
    args
  end

  defp append_app_name(args) do
    app_module = Mix.Project.config
    |> Keyword.fetch!(:app)
    |> Atom.to_string
    |> Mix.Phoenix.inflect

    List.insert_at(args, -1, app_module[:base])
  end

  defp module_exists?(module) do
    Mix.Phoenix.check_module_name_availability!(module) ||
    module_exists?(module, @model_path) ||
    module_exists?(module, @controllers_path)
  end
  defp module_exists?(module, path) do
    module = Module.concat module, nil
    case File.ls path do
      {:ok, files} -> Enum.any? files, fn(fname) ->
        Path.join(path, fname)
        |> matches_module_definition?(module)
      end
      {:error, _} -> false
    end
  end

  defp matches_module_definition?(file, module) do
    case File.read file do
      {:ok, contents} -> contents =~ ~r/defmodule\s*[A-Za-z0-9].+\.#{inspect module}/
      {:error, _} -> false
    end
  end

  defp validate_args!([resource_name, plural_resource_name] = args) do
    cond do
      String.contains?(resource_name, ":") ->
        raise_with_help()
      resource_name != Phoenix.Naming.camelize(resource_name) ->
        Mix.raise "Expected the resource name argument, #{inspect resource_name}, to be camelcase"
      plural_resource_name != Phoenix.Naming.underscore(plural_resource_name) ->
        Mix.raise "Expected the resource plural name argument, #{inspect plural_resource_name}, to be lowercase"
      true ->
        args
    end
  end

  defp validate_args!(_) do
    raise_with_help()
  end

  defp print_instructions do
    Mix.shell.info """
      ================================================

      Now you're ready to go, just make sure you follow the next simple steps:

      #  Run the migrations
      $ mix ecto.migrate

      ================================================
    """
  end

  defp raise_with_help do
    Mix.raise """
    mix keeper.install expects a singular and plural name of the resource that
    it should create or be applied to:

        mix keeper.install User users
    """
  end
end
