defmodule Algoritmi.Repo do
  use Ecto.Repo,
    otp_app: :algoritmi,
    adapter: Ecto.Adapters.SQLite3
end
