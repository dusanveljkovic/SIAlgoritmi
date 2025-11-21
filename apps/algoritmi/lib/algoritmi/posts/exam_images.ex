defmodule Algoritmi.Posts.ExamImage do
  use Ecto.Schema
  import Ecto.Changeset

  alias Algoritmi.RemoteStorage

  schema "exam_images" do
    field :url, :string
    field :page_number, :integer

    field :local_path, :string, virtual: true

    belongs_to :exam, Algoritmi.Posts.Exam

    timestamps()
  end

  @doc false
  def changeset(exam_image, attrs) do
    exam_image
    |> cast(attrs, [:url, :page_number, :local_path])
    |> validate_required([:page_number])
    |> validate_number(:page_number, greater_than_or_equal_to: 0)
    |> get_url()
  end

  defp get_url(changeset) do
    if local_path = get_field(changeset, :local_path) do
      put_change(changeset, :url, RemoteStorage.generate_url(local_path, "exam_images")) 
    else
      changeset
    end
  end

  def upload(%{local_path: local_path, url: url} = exam_image) do
    RemoteStorage.upload_image(local_path, url)
    exam_image
  end
end
