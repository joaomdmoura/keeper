defmodule Mix.Tasks.Keeper.InstallTest do
  use ExUnit.Case

  setup do
    Mix.Task.clear
    :ok
  end

  test "install task should work if resource name and its plural name are send" do
    assert Mix.Tasks.Keeper.Install.run ["User", "users"]

    on_exit fn ->
      # Cleaning support test files
      options = ["-rf", "priv/", "test/models/", "web/"]
      {_stdout, 0} = System.cmd("rm", options)
    end
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
end
