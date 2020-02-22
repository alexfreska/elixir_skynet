<a href="https://siasky.net"><img src="https://github.com/alexfreska/elixir_skynet/blob/master/assets/elixir.png" alt="Elixir" width="70" /><img src="https://github.com/alexfreska/elixir_skynet/blob/master/assets/skynet.svg" alt="Skynet" width="200" /></a>

Unofficial Elixir client for uploading and downloading files from <a href="https://sia.tech/">Sia</a> <a href="https://siasky.net/">Skynet</a>.


## Installation

The package can be installed by adding `skynet` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:skynet, "~> 0.1.0"}
  ]
end
```


## Usage

```elixir
# Uploading a file
{:ok, %{skylink: skylink}} = Skynet.upload("path/to/file.jpeg")

# Downloading a file
{:ok, %{file: file, filename: filename}} = Skynet.download(skylink)
```

The documentation can be found at [https://hexdocs.pm/skynet](https://hexdocs.pm/skynet).

## Remarks
<a href="https://sia/tech"><img src="https://github.com/alexfreska/elixir_skynet/blob/master/assets/built-with-sia.svg" alt="Built with Sia" width="80" /></a>
