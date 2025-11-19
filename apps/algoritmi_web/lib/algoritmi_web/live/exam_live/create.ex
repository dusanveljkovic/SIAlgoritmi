defmodule AlgoritmiWeb.ExamLive.Create do
  use AlgoritmiWeb, :live_view 
  require Logger

  alias Algoritmi.Posts
  alias Algoritmi.Posts.Exam
  alias Algoritmi.RemoteStorage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(form: to_form(Posts.change_exam(socket.assigns.current_scope, %Exam{}), as: "exam"))
      |> allow_upload(:pdf, accept: ~w(.pdf), max_entires: 1)}
  end

  @impl true
  def handle_event("save", %{"exam" => exam}, socket) do
    case Posts.create_exam(socket.assigns.current_scope, exam) do
      {:ok, exam} -> 
        generate_exam_images(socket) 
        |> Posts.create_exam_images(exam) 
        {:noreply,
          socket
          |> redirect(to: ~p"/exams")}

      {:error, changeset} -> 
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("change", _params, socket) do
    {:noreply, socket}
  end

  def generate_exam_images(socket) do
    consume_uploaded_entries(socket, :pdf, fn %{path: path}, _entry -> 
      images = 
        path
        |> RemoteStorage.pdf_to_images()
        |> RemoteStorage.dev_upload()
      {:ok, images} 
    end)
    |> List.flatten()
  end
end
