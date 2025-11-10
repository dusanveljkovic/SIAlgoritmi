defmodule Algoritmi.Posts.Exam do
  use Ecto.Schema
  import Ecto.Changeset

  schema "exams" do
    field :subject, :string
    field :year, :integer
    field :term, :string
    field :description, :string
    field :image_url, :string

    belongs_to :uploader, Algoritmi.Accounts.User,
      foreign_key: :uploaded_by,
      type: :integer

    timestamps()
  end

  @doc false
  def changeset(exam, attrs) do
    exam
    |> cast(attrs, [:subject, :year, :term, :description, :image_url])
    |> validate_required([:subject, :year, :term, :image_url])
    |> validate_number(:year, greater_than: 2003, less_than: 2026)
    |> validate_inclusion(:subject, ["ASP1", "ASP2"])
    |> validate_inclusion(:term, ["K1", "K2", "K3", "Januar", "Februar", "Jun", "Jul"])
  end
end
