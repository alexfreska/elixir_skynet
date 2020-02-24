<a href="https://siasky.net"><img src="https://github.com/alexfreska/elixir_skynet/blob/master/assets/elixir.png" alt="Elixir" width="70" /><img src="https://github.com/alexfreska/elixir_skynet/blob/master/assets/skynet.svg" alt="Skynet" width="200" /></a>

Unofficial Elixir client for uploading and downloading files from <a href="https://sia.tech/">Sia</a> <a href="https://siasky.net/">Skynet</a>.


## Installation
The package can be installed by adding `skynet` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:skynet, "~> 0.1.6"}
  ]
end
```

## Usage
```elixir
# Download a file using its Skylink
iex> Skynet.download("AADOl5bb0oXpmIWOK115bctmbV9Jogl-FcyMmIzb5MV1ZA")
{:ok,
  %{
    file: <<79, 103, 103, 83, 0, 2, 0, 0, 0, ...>>,
    filename: "Bach_Fugue_in_A-minor_BMW_543.opus"
  }
}

# Upload a file by providing its path
iex> Skynet.upload("path/to/file.jpeg")
{:ok,
  %{
    skylink: "AACEIgsvJKk7yY2y9Z-dXTh5niUAKwO_jH4LpbLiaw5X1g",
    # In addition to the Skylink, the merkleroot and bitfield are also returned for convenience
    merkleroot: "84220b2f24a93bc98db2f59f9d5d38799e25002b03bf8c7e0ba5b2e26b0e57d6",
    bitfield: 0
  }
}

# Configure options, like the target portal URL
iex> Skynet.upload("path/to/file.jpeg", portal_url: "https://skydrain.com")
{:ok,
  %{
    skylink: "AACEIgsvJKk7yY2y9Z-dXTh5niUAKwO_jH4LpbLiaw5X1g",
    merkleroot: "84220b2f24a93bc98db2f59f9d5d38799e25002b03bf8c7e0ba5b2e26b0e57d6",
    bitfield: 0
  }
}
```


The documentation can be found at [https://hexdocs.pm/skynet](https://hexdocs.pm/skynet).

## Remarks
<a href="https://sia/tech"><img src="https://github.com/alexfreska/elixir_skynet/blob/master/assets/built-with-sia.svg" alt="Built with Sia" width="80" /></a>
