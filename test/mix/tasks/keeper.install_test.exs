defmodule Mix.Tasks.Keeper.InstallTest do
  use ExUnit.Case
  alias Mix.Tasks.Keeper.Install.PathHelper

  @model_path PathHelper.model_path
  @templates_path PathHelper.templates_path
  @migrations_path PathHelper.migrations_path

  setup do
    Mix.Task.clear
    :ok
  end

  test "install task should work if resource name and its plural name are send" do
    assert successful_install
    clean_support_files
  end

  test "successful installation should result on a model module" do
    successful_install

    # Check if model module was copied correctly
    {:ok, files} = File.ls @model_path
    assert files == ["user.ex"]

    # Check for the correct module name
    Enum.each files, fn(fname) ->
      {:ok, contents} = Path.join(@model_path, fname) |> File.read
      assert contents =~ ~r/defmodule\s*[A-Za-z0-9].+\.User/
    end

    clean_support_files
  end

  test "successful installation should result on a new migration" do
    successful_install

    migration = File.ls!(@migrations_path)
    |> Enum.find(fn(name) -> name =~ ~r/[0-9]+\_create_users/ end)

    # Check if the migration was generated correctly
    assert migration == "000_create_users.exs"

    # Check if the content of the migration matches the template
    content = Path.join(@migrations_path, migration) |> File.read!

    template = @templates_path
    |> Path.join("migrations/create_resource.exs")
    |> File.read!

    assert String.contains? content, template

    clean_support_files
  end

  test "resource name must be passed as an argument" do
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Keeper.Install.run []
    end
  end

  test "resource name can't be lowercased" do
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Keeper.Install.run ["user"]
    end
  end

  test "resource plural name must be passed as an argument" do
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Keeper.Install.run ["User"]
    end
  end

  test "resource plural name must be lowercased" do
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Keeper.Install.run ["User", "User"]
    end
  end

  defp successful_install, do: Mix.Tasks.Keeper.Install.run ["User", "users"]

  defp clean_support_files do
    # Cleaning support test files
    {_stdout, 0} = System.cmd("rm", ["-rf", @model_path])
    {_stdout, 0} = System.cmd("rm", ["test/support/migrations/000_create_users.exs"])
  end
end
