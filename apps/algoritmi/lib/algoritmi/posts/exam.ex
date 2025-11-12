defmodule Algoritmi.Posts.Exam do
  use Ecto.Schema
  import Ecto.Changeset

  schema "exams" do
    field :subject, :string
    field :year, :integer
    field :term, :string
    field :description, :string

    belongs_to :uploader, Algoritmi.Accounts.User,
      foreign_key: :uploaded_by,
      type: :integer

    has_many :images, Algoritmi.Posts.ExamImage

    timestamps()
  end

  @doc false
  def changeset(exam, attrs) do
    exam
    |> cast(attrs, [:subject, :year, :term, :description])
    |> validate_required([:subject, :year, :term])
    |> validate_number(:year, greater_than: 2003, less_than: 2026)
    |> validate_inclusion(:subject, ["ASP1", "ASP2"])
    |> validate_inclusion(:term, ["K1", "K2", "K3", "Januar", "Februar", "Jun", "Jul"])
  end
end
