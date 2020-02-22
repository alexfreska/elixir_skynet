<a href="https://siasky.net"><img src="assets/elixir.png" alt="Elixir" width="70" /><img src="assets/skynet.svg" alt="Skynet" width="200" /></a>

Elixir client for interfacing with the <a href="https://sia.tech/">Sia</a> <a href="https://siasky.net/">Skynet</a> file sharing protocol.

## Installation

The package can be installed by adding `skynet` to your list of dependencies in `mix.exs`:

    def deps do
      [
        {:skynet, "~> 0.1.0"}
      ]
    end


## Usage
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
        bitfield: 0,
        merkleroot: "84220b2f24a93bc98db2f59f9d5d38799e25002b03bf8c7e0ba5b2e26b0e57d6",
        skylink: "AACEIgsvJKk7yY2y9Z-dXTh5niUAKwO_jH4LpbLiaw5X1g"
      }
    }

    # Configure the target portal URL to someting other than siasky.net
    iex> Skynet.upload("path/to/file.jpeg", portal_url: "https://skydrain.com")
    {:ok,
      %{
        bitfield: 0,
        merkleroot: "84220b2f24a93bc98db2f59f9d5d38799e25002b03bf8c7e0ba5b2e26b0e57d6",
        skylink: "AACEIgsvJKk7yY2y9Z-dXTh5niUAKwO_jH4LpbLiaw5X1g"
      }
    }

## Options
The upload and download methods both accept the following options:
- `:portal_url` - Configure the portal address, defaults to https://siasky.net
- `:portal_upload_path` - Configure the portal upload path, defaults to "/skynet/skyfile"
- `:portal_file_fieldname` - Configure the portal file fieldname, defaults to "file"
- `:headers` - Add headers to the request, eg: `[authorization: "Bearer <token>"]`
- `:timeout` - Configure the timeout, defaults to 5 seconds. Note: invalid Skylink will hang until the timeout elapses.

Please view the complete module documentation for more details.


## Remarks
<a href="https://sia/tech"><img src="assets/built-with-sia.svg" alt="Built with Sia" width="80" /></a>
