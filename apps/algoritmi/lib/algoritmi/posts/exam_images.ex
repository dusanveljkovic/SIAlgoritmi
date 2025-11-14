defmodule Algoritmi.Posts.ExamImage do
  use Ecto.Schema
  import Ecto.Changeset

  alias Algoritmi.Posts.Exam

  schema "exam_images" do
    field :url, :string
    field :page_number, :integer

    belongs_to :exam, Algoritmi.Posts.Exam

    timestamps()
  end

  @doc false
  def changeset(exam_image, attrs, %Exam{} = exam) do
    exam_image
    |> cast(attrs, [:url, :page_number])
    |> validate_required([:url, :page_number])
    |> put_assoc(:exam, exam)
    |> validate_number(:page_number, greater_than_or_equal_to: 0)
  end
end
