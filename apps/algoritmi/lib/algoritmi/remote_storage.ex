defmodule Algoritmi.RemoteStorage do
  @bucket "sialgoritmi"

  @doc """
  Uploads a single file from local path to base_url + remote_path
  """
  def upload_image(local_path, remote_path) do
    ExAws.S3.put_object(@bucket, remote_path , File.read!(local_path))
    |> ExAws.request!
  end

  @doc """
  Uplaods multiple images using Tasks
  """
  def upload_images(paths, name_f) do
    paths
    |> Task.async_stream(&upload_image(&1, name_f), max_concurrency: 10, ordered: true)
    |> Enum.map(fn {:ok, val} -> val end)
  end

  def base_url do
    "https://minio.dusanveljkovic.com/#{@bucket}"
  end

  def generate_url(path, folder) do
    "#{folder}/#{Path.basename(path)}"
  end

  def full_url(partial_path) do
    "#{base_url()}/#{partial_path}"
  end

  
end
