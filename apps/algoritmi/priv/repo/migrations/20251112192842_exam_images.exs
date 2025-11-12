defmodule Algoritmi.Repo.Migrations.ExamImages do
  use Ecto.Migration

  def change do
    alter table(:exams) do
      remove :image_url
    end

    create table(:exam_images) do
      add :url, :text, null: false
      add :page_number, :integer, null: false
      add :exam_id, references(:exams, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
