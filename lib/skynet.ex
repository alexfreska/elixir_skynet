defmodule Skynet do
  @moduledoc """
  Skynet is file sharing protocol built on top of the Sia network.
  This library provides simple methods for interacting with Skynet.
  """

  @doc """
  Download a file from Skynet.

  ## Arguments

  - `skylink` - Skylink identifer
  - `options` (optional) - Options for configuring the Portal and request
    - `:portal_url` - Configure the portal address, defaults to https://siasky.net
    - `:portal_upload_path` - Configure the portal upload path, defaults to "/skynet/skyfile"
    - `:portal_file_fieldname` - Configure the portal file fieldname, defaults to "file"
    - `:headers` - Add headers to the request, eg: `[authorization: "Bearer <token>"]`
    - `:timeout` - Configure the timeout, defaults to 5 seconds. Note: invalid Skylink will hang until the timeout elapses.

  ## Examples

      iex> Skynet.download("AADOl5bb0oXpmIWOK115bctmbV9Jogl-FcyMmIzb5MV1ZA")
      {:ok,
        %{
          file: <<79, 103, 103, 83, 0, 2, 0, 0, 0, ...>>,
          filename: "Bach_Fugue_in_A-minor_BMW_543.opus"
        }
      }
  """
  def download(skylink, options \\ []) do
    Skynet.Client.download(skylink, options)
  end

  @doc """
  Upload a file to Skynet.

  ## Arguments

  - `file_path` - Path to file location
  - `options` (optional) - Options for configuring the Portal and request
    - `:portal_url` - Configure the portal address, defaults to https://siasky.net
    - `:portal_upload_path` - Configure the portal upload path, defaults to "/skynet/skyfile"
    - `:portal_file_fieldname` - Configure the portal file fieldname, defaults to "file"
    - `:headers` - Add headers to the request, eg: `[authorization: "Bearer <token>"]`
    - `:timeout` - Configure the timeout, defaults to 5 seconds. Note: invalid Skylink will hang until the timeout elapses.

  ## Examples

      # Upload a file
      iex> Skynet.upload("path/to/file.jpeg")
      {:ok,
        %{
          bitfield: 0,
          merkleroot: "84220b2f24a93bc98db2f59f9d5d38799e25002b03bf8c7e0ba5b2e26b0e57d6",
          skylink: "AACEIgsvJKk7yY2y9Z-dXTh5niUAKwO_jH4LpbLiaw5X1g"
        }
      }

      # Configure the upload's target portal URL and timeout
      iex> Skynet.upload("path/to/file.jpeg", portal_url: "https://skydrain.net", timeout: 6_000)
      {:ok,
        %{
          bitfield: 0,
          merkleroot: "84220b2f24a93bc98db2f59f9d5d38799e25002b03bf8c7e0ba5b2e26b0e57d6",
          skylink: "AACEIgsvJKk7yY2y9Z-dXTh5niUAKwO_jH4LpbLiaw5X1g"
        }
      }
  """
  def upload(file_path, options \\ []) do
    Skynet.Client.upload(file_path, options)
  end
end
