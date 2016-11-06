defmodule Mix.Tasks.Keeper.InstallTest do
  use ExUnit.Case

  setup do
    Mix.Task.clear
    :ok
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
end
