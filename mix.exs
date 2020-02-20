defmodule Skynet.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :skynet,
      name: "skynet",
      version: @version,
      description: description(),
      package: package(),
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/alexfreska/elixir_skynet"
    ]
  end

  defp description do
    "Client for uploading and downloading files from Sia Skynet"
  end

  defp package do
    [
      maintainers: ["Alex Freska"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/alexfreska/elixir_skynet"}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21.3", only: :dev},
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.15.2"},
      {:jason, ">= 1.0.0"},
      {:uuid, "~> 1.1.8"}
    ]
  end
end
