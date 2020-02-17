# Elixir Skynet

Skynet client for uploading and downloading files from Sia Skynet

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

