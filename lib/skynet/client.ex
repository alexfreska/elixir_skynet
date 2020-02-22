defmodule Skynet.Client do
  @moduledoc false

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

  def upload(file_path, options \\ []) do
    config = build_config(options)
    client = build_client(config)

    upload_path = Keyword.get(config, :portal_upload_path) <> "/" <> UUID.uuid4()

    body =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_file(file_path, name: Keyword.get(config, :portal_file_fieldname))

    post(client, upload_path, body)
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
      {Tesla.Middleware.Timeout, timeout: Keyword.get(config, :timeout)},
      Tesla.Middleware.FormUrlencoded,
      # Tesla.Middleware.Logger
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
