defmodule AlgoritmiWeb.PageController do
  use AlgoritmiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
