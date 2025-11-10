defmodule Algoritmi.Repo.Migrations.CreateExams do
  use Ecto.Migration

  def change do
    create table(:exams) do
      add :subject, :string, null: false
      add :year, :integer, null: false
      add :term, :string, null: false
      add :description, :text
      add :image_url, :text, null: false
      add :uploaded_by, references(:users, on_delete: :nilify_all), null: false

      timestamps()
    end
  end
end
