defmodule Algoritmi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Algoritmi.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:algoritmi, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:algoritmi, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Algoritmi.PubSub}
      # Start a worker by calling: Algoritmi.Worker.start_link(arg)
      # {Algoritmi.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Algoritmi.Supervisor)
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end
end
