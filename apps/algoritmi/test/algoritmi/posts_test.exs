defmodule Algoritmi.PostsTest do
  use Algoritmi.DataCase

  alias Algoritmi.Posts

  describe "exams" do
    alias Algoritmi.Posts.Exam

    import Algoritmi.AccountsFixtures, only: [user_scope_fixture: 0]
    import Algoritmi.PostsFixtures

    @invalid_attrs %{term: nil, description: nil, year: nil, subject: nil, image_url: nil, uploaded_at: nil}

    test "list_exams/1 returns all scoped exams" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exam = exam_fixture(scope)
      other_exam = exam_fixture(other_scope)
      assert Posts.list_exams(scope) == [exam]
      assert Posts.list_exams(other_scope) == [other_exam]
    end

    test "get_exam!/2 returns the exam with given id" do
      scope = user_scope_fixture()
      exam = exam_fixture(scope)
      other_scope = user_scope_fixture()
      assert Posts.get_exam!(scope, exam.id) == exam
      assert_raise Ecto.NoResultsError, fn -> Posts.get_exam!(other_scope, exam.id) end
    end

    test "create_exam/2 with valid data creates a exam" do
      valid_attrs = %{term: "some term", description: "some description", year: 42, subject: "some subject", image_url: "some image_url", uploaded_at: ~N[2025-11-09 16:29:00]}
      scope = user_scope_fixture()

      assert {:ok, %Exam{} = exam} = Posts.create_exam(scope, valid_attrs)
      assert exam.term == "some term"
      assert exam.description == "some description"
      assert exam.year == 42
      assert exam.subject == "some subject"
      assert exam.image_url == "some image_url"
      assert exam.uploaded_at == ~N[2025-11-09 16:29:00]
      assert exam.user_id == scope.user.id
    end

    test "create_exam/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.create_exam(scope, @invalid_attrs)
    end

    test "update_exam/3 with valid data updates the exam" do
      scope = user_scope_fixture()
      exam = exam_fixture(scope)
      update_attrs = %{term: "some updated term", description: "some updated description", year: 43, subject: "some updated subject", image_url: "some updated image_url", uploaded_at: ~N[2025-11-10 16:29:00]}

      assert {:ok, %Exam{} = exam} = Posts.update_exam(scope, exam, update_attrs)
      assert exam.term == "some updated term"
      assert exam.description == "some updated description"
      assert exam.year == 43
      assert exam.subject == "some updated subject"
      assert exam.image_url == "some updated image_url"
      assert exam.uploaded_at == ~N[2025-11-10 16:29:00]
    end

    test "update_exam/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exam = exam_fixture(scope)

      assert_raise MatchError, fn ->
        Posts.update_exam(other_scope, exam, %{})
      end
    end

    test "update_exam/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      exam = exam_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Posts.update_exam(scope, exam, @invalid_attrs)
      assert exam == Posts.get_exam!(scope, exam.id)
    end

    test "delete_exam/2 deletes the exam" do
      scope = user_scope_fixture()
      exam = exam_fixture(scope)
      assert {:ok, %Exam{}} = Posts.delete_exam(scope, exam)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_exam!(scope, exam.id) end
    end

    test "delete_exam/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exam = exam_fixture(scope)
      assert_raise MatchError, fn -> Posts.delete_exam(other_scope, exam) end
    end

    test "change_exam/2 returns a exam changeset" do
      scope = user_scope_fixture()
      exam = exam_fixture(scope)
      assert %Ecto.Changeset{} = Posts.change_exam(scope, exam)
    end
  end
end
