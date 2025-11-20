defmodule Algoritmi.RemoteStorage do
  import Mogrify
  import ExAws

  alias Algoritmi.Posts.ExamImage

  @bucket "sialgoritmi"

  @doc """
  Uploads a single image to a path got by applying name_f on path
  """
  def upload_image(path, name_f) do
    name = name_f.(path)

    ExAws.S3.put_object(@bucket, name, File.read!(path))
    |> ExAws.request!

    "#{base_url()}/#{name}"
  end

  @doc """
  Uplaods multiple images using Tasks
  """
  def upload_images(paths, name_f) do
    paths
    |> Task.async_stream(&upload_image(&1, name_f), max_concurrency: 10, ordered: true)
    |> Enum.map(fn {:ok, val} -> val end)
  end

  def dev_upload(paths) do
    upload_images(paths, fn x -> "dev/#{Path.basename(x)}" end)
  end


  def base_url do
    "https://minio.dusanveljkovic.com/#{@bucket}"
  end

  def temp_upload(path) do
    "temp/#{Path.basename(path)}"
  end

  def generate_url(path, folder) do
    "#{folder}/#{Path.basename(path)}"
  end

  
end
