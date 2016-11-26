defmodule Mix.Tasks.Keeper.InstallTest do
  use ExUnit.Case

  @web_path "web/"
  @model_path "web/models"

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
    options = ["-rf", @web_path]
    {_stdout, 0} = System.cmd("rm", options)
  end
end
