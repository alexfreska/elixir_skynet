defmodule SkynetTest do
  use ExUnit.Case

  @test_file_path "test/sample.txt"

  test "Uploads and downloads a file" do
    {:ok, %{skylink: skylink}} = Skynet.upload(@test_file_path)
    {:ok, %{file: file}} = Skynet.download(skylink)
    assert file == File.read!(@test_file_path)
  end
end
