defmodule Algoritmi.RemoteStorage do
  import Mogrify
  import ExAws

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
    |> Task.async_stream(&upload_image(&1, name_f), max_concurrency: 10)
    |> Enum.map(fn {:ok, val} -> val end)
  end

  def dev_upload(paths) do
    upload_images(paths, fn x -> "dev/#{Path.basename(x)}" end)
  end

  @doc """
  Converts each page of a pdf to a separate image and returns the list of paths to them
  """
  def pdf_to_images(pdf_path) do
    %{frame_count: page_count} = Mogrify.identify(pdf_path)

    %{path: converted_path} = pdf_path
    |> Mogrify.open()
    |> Mogrify.format("png")
    |> Mogrify.save()

    base = Path.rootname(converted_path)
    ext = Path.extname(converted_path)

    for i <- 0..(page_count - 1) do
      "#{base}-#{i}#{ext}" 
    end
  end

  def base_url do
    "https://minio.dusanveljkovic.com/#{@bucket}"
  end

  def temp_upload(path) do
    "temp/#{Path.basename(path)}"
  end

  
end
