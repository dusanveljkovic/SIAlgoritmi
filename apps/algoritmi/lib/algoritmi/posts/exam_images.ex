defmodule Algoritmi.Posts.ExamImage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "exam_images" do
    field :url, :string
    field :page_number, :integer

    belongs_to :exam, Algoritmi.Posts.Exam

    timestamps()
  end

  @doc false
  def changeset(exam, attrs) do
    exam
    |> cast(attrs, [:url, :page_number])
    |> validate_required([:url, :page_number])
    |> validate_number(:page_number, greater_than_or_equal: 0)
  end
end
