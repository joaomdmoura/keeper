# Keeper

Flexible and out of the box authentication solution for Phoenix ~ Devise like

## Installation

  1. Add `keeper` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:keeper, "~> 0.0.1-rc"}]
    end
    ```

  2. Ensure `keeper` is started before your application:

    ```elixir
    def application do
      [applications: [:keeper]]
    end
    ```
