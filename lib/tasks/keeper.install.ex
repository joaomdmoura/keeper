defmodule Mix.Tasks.Keeper.Install do
  use Mix.Task

  @shortdoc "Installs the Keeper to the Pheonix Application"

  @moduledoc """
  Installs Keeper for a specific Phoenix resource.

      mix keeper.install User users

  The first argument is the module name followed by its plural
  name.

  The installation task will follow:

    * Add :keeper configuration to `config/config.exs`.
    * Check for resource existence / Create the resource.
    * Generate migration files.
    * Generate view files.
  """

  @doc """
  Main method for the install task
  """
  def run(args) do
    {_, parsed, _} = OptionParser.parse(args)
    valid_args = parsed |> validate_args!

    generate_model(valid_args)

    print_instructions
  end

  defp generate_model([resource_name, plural_resource_name] = _args) do
    unless model_defined?(resource_name) do
      Mix.Tasks.Phoenix.Gen.Model.run [
        resource_name,
        plural_resource_name,
        "email:string",
        "password_hash:string"
      ]
    end
  end

  defp print_instructions do
   Mix.shell.info """
     Now you're ready to go, just make sure you follow the next simple steps:

     #  Run the migrations
     $ mix ecto.migrate
     """
  end

  defp model_defined?(model) do
    Mix.Phoenix.check_module_name_availability!(model) || module_exists?(model, "web/models")
  end

  defp module_exists?(model, path) do
    module = Module.concat model, nil
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

  defp raise_with_help do
    Mix.raise """
    mix keeper.install expects a singular name of the resource that it should
    create or be applied to:

        mix keeper.install User users
    """
  end
end
