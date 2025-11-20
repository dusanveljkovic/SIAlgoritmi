defmodule Algoritmi.Posts.Exam do
  use Ecto.Schema
  import Ecto.Changeset

  alias Algoritmi.Accounts.Scope
  alias Algoritmi.Posts.ExamImage

  schema "exams" do
    field :subject, :string
    field :year, :integer
    field :term, :string
    field :description, :string

    field :pdf_path, :string, virtual: true

    belongs_to :uploader, Algoritmi.Accounts.User,
      foreign_key: :uploaded_by,
      type: :integer

    has_many :images, Algoritmi.Posts.ExamImage

    timestamps()
  end

  @doc false
  def changeset(exam, attrs, %Scope{user: user}) do
    exam
    |> cast(attrs, [:subject, :year, :term, :description, :pdf_path])
    |> validate_required([:subject, :year, :term, :pdf_path])
    |> put_assoc(:uploader, user)
    |> validate_number(:year, greater_than: 2003, less_than: 2026)
    |> validate_inclusion(:subject, ["ASP1", "ASP2"])
    |> validate_inclusion(:term, ["K1", "K2", "K3", "Januar", "Februar", "Jun", "Jul"])
    |> prepare_changes(&create_images/1)
  end

  defp create_images(changeset) do
    pdf_path = get_change(changeset, :pdf_path)
    image_paths = pdf_to_images(pdf_path)
    exam_images = for {img_path, index} <- Enum.with_index(image_paths) do
      %ExamImage{}
      |> ExamImage.changeset(%{local_path: img_path, page_number: index})
      |> apply_changes()
    end

    put_assoc(changeset, :images, exam_images)
  end

  defp pdf_to_images(pdf_path) do
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
end
