defmodule Algoritmi.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Algoritmi.Posts` context.
  """

  @doc """
  Generate a exam.
  """
  def exam_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        image_url: "some image_url",
        subject: "some subject",
        term: "some term",
        uploaded_at: ~N[2025-11-09 16:29:00],
        year: 42
      })

    {:ok, exam} = Algoritmi.Posts.create_exam(scope, attrs)
    exam
  end
end
