defmodule Ppc.MixProject do
  use Mix.Project

  def project do
    [
      app: :ppc,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ppc.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:finch, "~> 0.10.2"},
      {:jason, "~> 1.3"},
      {:dotenv, "~> 3.0.0"},
      {:ex_doc, "~> 0.28.2", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:bypass, "~> 2.1", only: :test},
      {:iteraptor, "~> 1.13"},
      {:exvcr, "~> 0.13", only: :test}
    ]
  end
end
