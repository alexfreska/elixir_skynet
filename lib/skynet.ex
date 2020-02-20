defmodule Skynet do
  @moduledoc """
  Skynet is file sharing protocol built on top of the Sia network.
  This library provides simple methods for interacting with Skynet.

  ### Examples

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
          skylink: "BAxOl5bb0oXpmIWOK115bctmbV9Jogl-FcyMmIzb5mV1Za" 
        }
      }

      # Configure the target portal URL to someting other than siasky.net
      iex> Skynet.upload("path/to/file.jpeg", portal_url: "https://skydrain.com")
      {:ok,
        %{
          skylink: "BAxOl5bb0oXpmIWOK115bctmbV9Jogl-FcyMmIzb5mV1Za" 
        }
      }

  ## Options

  The upload and download methods both accept the following options:
  - `:portal_url` - Configure the portal address, defaults to https://siasky.net
  - `:portal_upload_path` - Configure the portal upload path, defaults to "/skynet/skyfile"
  - `:portal_file_fieldname` - Configure the portal file fieldname, defaults to "file"
  - `:custom_filename` - ??
  - `:headers` - Add headers to the request, eg: `[authorization: "Bearer <token>"]`
  - `:timeout` - Configure the timeout, defaults to 5 seconds. Note: invalid Skylink will hang until the timeout elapses.

  """

  @default_config [
    portal_url: "https://siasky.net",
    portal_upload_path: "/skynet/skyfile",
    portal_file_fieldname: "file",
    custom_filename: "",
    base_file_path: "/",
    headers: [],
    timeout: 5_000
  ]

  use Tesla, docs: false

  @doc """
  Download a file from Skynet.

  ## Arguments

  - `skylink` - Skylink identifer
  - `options` (optional) - Options for configuring the Portal and request
    - `:portal_url` - Configure the portal address, defaults to https://siasky.net
    - `:portal_upload_path` - Configure the portal upload path, defaults to "/skynet/skyfile"
    - `:portal_file_fieldname` - Configure the portal file fieldname, defaults to "file"
    - `:custom_filename` - ??
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
    config = build_config(options)
    client = build_client(config)

    get(client, skylink)
    |> case do
      {:ok, %Tesla.Env{body: body, headers: headers}} ->
        {:ok, %{file: body, filename: get_filename(headers)}}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Upload a file to Skynet.

  ## Arguments

  - `file_path` - Path to file location
  - `options` (optional) - Options for configuring the Portal and request
    - `:portal_url` - Configure the portal address, defaults to https://siasky.net
    - `:portal_upload_path` - Configure the portal upload path, defaults to "/skynet/skyfile"
    - `:portal_file_fieldname` - Configure the portal file fieldname, defaults to "file"
    - `:custom_filename` - ??
    - `:headers` - Add headers to the request, eg: `[authorization: "Bearer <token>"]`
    - `:timeout` - Configure the timeout, defaults to 5 seconds. Note: invalid Skylink will hang until the timeout elapses.

  ## Examples

      # Upload a file
      iex> Skynet.upload("path/to/file.jpeg")
      {:ok,
        %{
          skylink: "BAxOl5bb0oXpmIWOK115bctmbV9Jogl-FcyMmIzb5mV1Za" 
        }
      }

      # Configure the upload's target portal URL and timeout
      iex> Skynet.upload("path/to/file.jpeg", portal_url: "https://skydrain.com", timeout: 6_000)
      {:ok,
        %{
          skylink: "BAxOl5bb0oXpmIWOK115bctmbV9Jogl-FcyMmIzb5mV1Za" 
        }
      }
  """
  def upload(file_path, options \\ []) do
    config = build_config(options)
    client = build_client(config)

    body =
      Multipart.new()
      |> Multipart.add_file(file_path, name: Keyword.get(config, :portal_file_fieldname))
    
    upload_path = Keyword.get(config, :portal_upload_path) <> "/" <> UUID.uuid4()

    upload_path
    |> post(client, body)
    |> case do
      {:ok, %Tesla.Env{body: body}} -> {:ok, transform_body(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Build config by merging user defined options into defaults.
  """
  defp build_config(options \\ []) do
    Keyword.merge(@default_config, options)
  end

  @doc """
  Build Tesla client and configure request middleware.
  """
  defp build_client(options \\ []) do
    config = build_config(options)
    params = [
      {Tesla.Middleware.BaseUrl, Keyword.get(config, :portal_url)},
      {Tesla.Middleware.Headers, Keyword.get(config, :headers)},
      {Tesla.Middleware.Timeout, Keyword.get(config, :timeout)},
      {Tesla.Middleware.FormUrlencoded},
      {Tesla.Middleware.Logger}
    ]
    Tesla.client(params)
  end

  @doc """
  Download response helper that gets filename from content disposition header.
  """
  defp get_filename(headers) do
    content_disposition =
      Enum.find(headers, fn {name, value} -> name == "content-disposition" end)

    case content_disposition do
      {key, value} -> String.split(value, ~s(filename=\")) |> Enum.at(1) |> String.slice(0..-2)
      nil -> ""
    end
  end

  @doc """
  Response helper that decodes JSON and transforms top level keys into atoms.
  """
  defp transform_body(body) do
    body
    |> Jason.decode!()
    |> transform_keys_to_atoms()
  end

  @doc """
  Transforms a map's top level keys into atoms.
  """
  defp transform_keys_to_atoms(map) do
    map
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end
end
