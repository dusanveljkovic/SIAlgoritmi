defmodule AlgoritmiWeb.ExamLive.Edit do
  use AlgoritmiWeb, :live_view 
  require Logger

  alias Algoritmi.Posts
  alias Algoritmi.Posts.Exam

  @impl true
  def mount(%{"exam_id" => exam_id}, _session, socket) do
    case Posts.get_exam(exam_id) do
      nil -> 
        {:ok,
          socket
          |> put_flash(:error, "Rok ne postoji")
          |> push_navigate(to: "/")}

      exam -> 
        {:ok, assign(socket, :exam, exam)}
    end
  end
end
