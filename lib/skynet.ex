defmodule Skynet do
  @moduledoc """
  Documentation for Skynet.
  """

  use Tesla
  alias Tesla.Multipart

  @portal_url "https://siasky.net"
  @portal_upload_path "/skynet/skyfile"
  @portal_file_fieldname "file"
  @custom_filename ""
  @base_file_path "/"

  plug(Tesla.Middleware.BaseUrl, @portal_url)
  plug(Tesla.Middleware.Headers, [])
  plug(Tesla.Middleware.Timeout, timeout: 5_000)
  plug(Tesla.Middleware.FormUrlencoded)
  plug(Tesla.Middleware.Logger)

  @doc """
  Download a file from Skynet

  ## Examples

      iex> Skynet.download("AADOl5bb0oXpmIWOK115bctmbV9Jogl-FcyMmIzb5MV1ZA")
      {:ok,
        %{
          file: <<79, 103, 103, 83, 0, 2, 0, 0, 0, ...>>,
          filename: "Bach_Fugue_in_A-minor_BMW_543.opus"
        }
      }
  """
  def download(skylink) do
    get(skylink)
    |> case do
      {:ok, %Tesla.Env{body: body, headers: headers}} ->
        {:ok, %{file: body, filename: get_filename(headers)}}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Upload a file to Skynet

  ## Examples

      iex> Skynet.upload("path/to/file.jpeg")
      {:ok,
        %{
          skylink: "BAxOl5bb0oXpmIWOK115bctmbV9Jogl-FcyMmIzb5mV1Za" 
        }
      }
  """
  def upload(file_path) do
    body =
      Multipart.new()
      |> Multipart.add_file(file_path, name: @portal_file_fieldname)
    
    upload_path = @portal_upload_path <> "/" <> UUID.uuid4()

    upload_path
    |> post(body)
    |> case do
      {:ok, %Tesla.Env{body: body}} -> {:ok, transform_body(body)}
      {:error, error} -> {:error, error}
    end
  end

  defp get_filename(headers) do
    content_disposition =
      Enum.find(headers, fn {name, value} -> name == "content-disposition" end)

    case content_disposition do
      {key, value} -> String.split(value, ~s(filename=\")) |> Enum.at(1) |> String.slice(0..-2)
      nil -> ""
    end
  end

  defp transform_body(body) do
    body
    |> Jason.decode!()
    |> transform_keys_to_atoms()
  end

  defp transform_keys_to_atoms(map) do
    map
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end
end
