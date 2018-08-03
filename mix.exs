defmodule RaeBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :rae_bot,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RaeBot, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram,
       git: "https://github.com/rockneurotiko/ex_gram", branch: "update_api_fix_type_checks"},
      {:tesla, "~> 1.0.0"},
      {:jason, "~> 1.1"}
    ]
  end
end
