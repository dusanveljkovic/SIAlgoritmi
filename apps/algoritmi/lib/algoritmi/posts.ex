defmodule Algoritmi.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Algoritmi.Repo

  alias Algoritmi.Posts.Exam
  alias Algoritmi.Accounts.Scope
  alias Algoritmi.Posts.ExamImage
  alias Algoritmi.RemoteStorage

  import Mogrify

  @doc """
  Subscribes to scoped notifications about any exam changes.

  The broadcasted messages match the pattern:

    * {:created, %Exam{}}
    * {:updated, %Exam{}}
    * {:deleted, %Exam{}}

  """
  def subscribe_exams(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Algoritmi.PubSub, "user:#{key}:exams")
  end

  defp broadcast_exam(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Algoritmi.PubSub, "user:#{key}:exams", message)
  end

  @doc """
  Returns the list of exams.

  ## Examples

      iex> list_exams(scope)
      [%Exam{}, ...]

  """
  def list_exams() do
    query = 
      from e in Exam,
        as: :exam,
        preload: [:images]
    Repo.all(query)
  end

  @doc """
  Gets a single exam.

  Raises `Ecto.NoResultsError` if the Exam does not exist.

  ## Examples

      iex> get_exam!(scope, 123)
      %Exam{}

      iex> get_exam!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_exam!(id) do
    Repo.get_by!(Exam, id: id)
  end

  @doc """
  Creates a exam.

  ## Examples

      iex> create_exam(scope, %{field: value})
      {:ok, %Exam{}}

      iex> create_exam(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_exam(%Scope{} = scope, attrs) do
    with {:ok, exam = %Exam{}} <-
           %Exam{}
           |> Exam.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_exam(scope, {:created, exam})
      {:ok, exam}
    end
  end



  @doc """
  Updates a exam.

  ## Examples

      iex> update_exam(scope, exam, %{field: new_value})
      {:ok, %Exam{}}

      iex> update_exam(scope, exam, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_exam(%Scope{} = scope, %Exam{} = exam, attrs) do
    true = exam.uploader == scope.user.id

    with {:ok, exam = %Exam{}} <-
           exam
           |> Exam.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_exam(scope, {:updated, exam})
      {:ok, exam}
    end
  end

  @doc """
  Deletes a exam.

  ## Examples

      iex> delete_exam(scope, exam)
      {:ok, %Exam{}}

      iex> delete_exam(scope, exam)
      {:error, %Ecto.Changeset{}}

  """
  def delete_exam(%Scope{} = scope, %Exam{} = exam) do
    true = exam.uploader == scope.user.id

    with {:ok, exam = %Exam{}} <-
           Repo.delete(exam) do
      broadcast_exam(scope, {:deleted, exam})
      {:ok, exam}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking exam changes.

  ## Examples

      iex> change_exam(scope, exam)
      %Ecto.Changeset{data: %Exam{}}

  """
  def change_exam(%Scope{} = scope, %Exam{} = exam, attrs \\ %{}) do
    Exam.changeset(exam, attrs, scope)
  end

  def list_exam_images(%Exam{id: exam_id}) do
    Repo.all_by(ExamImage, exam_id: exam_id)
  end


  
  # def update_exam(%Scope{} = scope, %Exam{} = exam, attrs) do
  #   true = exam.uploader == scope.user.id
  #
  #   with {:ok, exam = %Exam{}} <-
  #          exam
  #          |> Exam.changeset(attrs, scope)
  #          |> Repo.update() do
  #     broadcast_exam(scope, {:updated, exam})
  #     {:ok, exam}
  #   end
  # end
  #
  # def delete_exam_images(%Scope{} = scope, %Exam{} = exam) do
  #   true = exam.uploader == scope.user.id
  #
  #   with {:ok, exam = %Exam{}} <-
  #          Repo.delete(exam) do
  #     broadcast_exam(scope, {:deleted, exam})
  #     {:ok, exam}
  #   end
  # end
  #
  # def change_exam(%Scope{} = scope, %Exam{} = exam, attrs \\ %{}) do
  #   Exam.changeset(scope, exam, attrs)
  # end

end
