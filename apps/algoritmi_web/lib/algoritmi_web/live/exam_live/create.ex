defmodule AlgoritmiWeb.ExamLive.Create do
  use AlgoritmiWeb, :live_view 
  require Logger

  alias Algoritmi.Posts
  alias Algoritmi.Posts.Exam

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(form: to_form(Posts.change_exam(%Exam{}), as: "exam"))
      |> allow_upload(:pdf, accept: ~w(.pdf), max_entires: 1)}
  end


end
