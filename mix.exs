defmodule Skynet.MixProject do
  use Mix.Project

  @version "0.1.2"

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
      source_url: "https://github.com/alexfreska/elixir_skynet",
      docs: docs()
    ]
  end

  defp description do
    "Client for interfacing with the Sia Skynet file sharing protocol"
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

  def docs do
    [
      api_reference: false,
      main: Skynet,
      extra_section: "Guides"
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
