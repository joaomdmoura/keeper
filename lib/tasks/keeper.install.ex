defmodule Mix.Tasks.Keeper.Install do
  use Mix.Task

  @shortdoc "Installs the Keeper to the Pheonix Application"

  @moduledoc """
  Installs Keeper for a specific Phoenix resource.

      mix keeper.install User

  The argument is the module name.

  The installation task will follow:

    * Add :keeper configuration to `config/config.exs`.
    * Check for resource existence / Create the resource.
    * Generate migration files.
    * Generate view files.
  """

  def run(args) do
    {_, parsed, _} = OptionParser.parse(args)
    validate_args!(parsed)
  end

  defp model_defined?(model) do
    schema = Module.concat model, nil
    Code.ensure_compiled?(schema) || module_exists?(schema, "web/models")
  end

  defp module_exists?(module, path) do
    case File.ls path do
      {:ok, files} ->
        Enum.any? files, fn fname ->
          case File.read Path.join(path, fname) do
            {:ok, contents} ->
              contents =~ ~r/defmodule\s*#{inspect module}/
            {:error, _} -> false
          end
        end
      {:error, _} -> false
    end
  end

  defp validate_args!([model_name] = args) do
    cond do
      String.contains?(model_name, ":") ->
        raise_with_help()
      model_name != Phoenix.Naming.camelize(model_name) ->
        Mix.raise "Expected the resource name argument, #{inspect model_name}, to be camelcase"
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

        mix keeper.install User
    """
  end
end
