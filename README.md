# Keeper

Flexible and out of the box authentication solution for Phoenix ~ Devise like

[![Build Status](https://travis-ci.org/joaomdmoura/keeper.svg?branch=master)](https://travis-ci.org/joaomdmoura/keeper)
[![Inline docs](http://inch-ci.org/github/joaomdmoura/keeper.svg)](http://inch-ci.org/github/joaomdmoura/keeper)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/joaomdmoura/keeper.svg)](https://beta.hexfaktor.org/github/joaomdmoura/keeper)

## Disclaimer
**Keeper** is under heavy development and is still on it's first RC, you are more then welcome to contribute, but I'd definitely not recommend using it right now.

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

  3. Run the installer

    You can replace `User` by the name of the module you want **Keeper** to create,
    or be applied to (if it already exists).
    ```
    $ mix keeper.install User
    ```
