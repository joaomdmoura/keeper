defmodule Keeper.Mixfile do
  use Mix.Project

  @version "0.0.1-rc"
  @maintainers ["João M. D. Moura"]
  @description """
    Flexible and out of the box authentication solution for Phoenix ~ Devise like
  """

  def project do
    [app: :keeper,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: @description,
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger, :comeonin]]
  end

  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:comeonin, "~> 2.5"}]
  end

  defp package do
    [
     name: :keeper,
     files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     maintainers: @maintainers,
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/joaomdmoura/keeper"}
    ]
  end
end
