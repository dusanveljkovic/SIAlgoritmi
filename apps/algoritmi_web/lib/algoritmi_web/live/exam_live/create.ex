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
  def handle_event("test-upload", _params, socket) do
    consume_uploaded_entries(socket, :pdf, fn %{path: path}, _entry -> 
      Posts.create_exam_images(Posts.get_exam!(1), path)
        end)
    {:noreply, assign(socket, uploaded_images: )}
  end

end
