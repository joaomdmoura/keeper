defmodule Mix.Tasks.Keeper.InstallTest do
  use ExUnit.Case
  alias Mix.Tasks.Keeper.Install.PathHelper

  @model_path PathHelper.env_path(:model_path)
  @router_path PathHelper.env_path(:router_path)
  @templates_path PathHelper.env_path(:templates_path)
  @migrations_path PathHelper.env_path(:migrations_path)
  @controllers_path PathHelper.env_path(:controllers_path)

  setup do
    Mix.Task.clear
    :ok
  end

  test "install task should work if resource name and its plural name are send" do
    assert successful_install
    on_exit &clean_support_files/0
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

    on_exit &clean_support_files/0
  end

  test "successful installation should update the router with new routes" do
    successful_install

    # Check for the new auth routes
    {:ok, contents} = Path.join(@router_path, "router.ex") |> File.read
    assert contents =~ ~r/resources "\/users", UserController, only: \[:create\]/

    on_exit &clean_support_files/0
  end

  test "successful installation should create a new controller" do
    successful_install

    # Check for the new controller declaration
    {:ok, contents} = Path.join(@controllers_path, "user_controller.ex") |> File.read
    assert contents =~ ~r/defmodule Keeper.UserController do/

    on_exit &clean_support_files/0
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

    on_exit &clean_support_files/0
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

  defp successful_install do
    {_stdout, 0} = System.cmd("cp",
      [Path.join(@router_path, "router_template.ex"), Path.join(@router_path, "router.ex")]
    )
    Mix.Tasks.Keeper.Install.run ["User", "users"]
  end

  defp clean_support_files do
    # Cleaning support test files
    {_stdout, 0} = System.cmd("rm", ["-rf", Path.join(@router_path, "router.ex")])
    {_stdout, 0} = System.cmd("rm", ["-rf", @model_path])
    {_stdout, 0} = System.cmd("rm", ["-rf", @controllers_path])
    {_stdout, 0} = System.cmd("rm", ["test/support/migrations/000_create_users.exs"])
  end
end
