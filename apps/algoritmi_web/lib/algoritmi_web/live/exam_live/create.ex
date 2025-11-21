defmodule AlgoritmiWeb.ExamLive.Create do
  use AlgoritmiWeb, :live_view 
  require Logger

  alias Algoritmi.Posts
  alias Algoritmi.Posts.Exam

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(form: to_form(Posts.change_exam(socket.assigns.current_scope, %Exam{}), as: "exam"))
      |> allow_upload(:pdf, accept: ~w(.pdf), max_entires: 1)}
  end

  @impl true
  def handle_event("save", %{"exam" => exam}, socket) do
    pdf_path = extract_pdf_path(socket)
    case Posts.create_exam(socket.assigns.current_scope, Map.put(exam, "pdf_path", pdf_path)) do
      {:ok, exam} -> 
        {:noreply,
          socket
          |> redirect(to: ~p"/exams/#{exam.id}")}

      {:error, changeset} -> 
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("change", _params, socket) do
    {:noreply, socket}
  end

  defp extract_pdf_path(socket) do
    consume_uploaded_entries(socket, :pdf, fn %{path: path}, _entry -> 
      File.cp!(path, "#{path}.pdf")
      {:ok, "#{path}.pdf"} 
    end) 
    |> List.flatten() 
    |> List.first()
  end
end
