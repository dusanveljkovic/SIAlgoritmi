defmodule AlgoritmiWeb.ExamLive.List do
  use AlgoritmiWeb, :live_view

  alias Algoritmi.Posts

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(Posts.list_exams())
    {:ok, assign(socket, exams: Posts.list_exams())} 
  end
end
