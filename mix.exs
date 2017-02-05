defmodule WhereAmIBackend.Mixfile do
  use Mix.Project

  def project do
    [app: :where_am_i_com,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      application: [:cowboy, :plug, :poison, :poolboy],
      extra_applications: [:logger],
      mod: {WhereAmIBackend, []},
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:poison, "~> 3.0"},
      {:redix, ">= 0.0.0"},
      {:poolboy,  github: "devinus/poolboy" },
    ]
  end
end
