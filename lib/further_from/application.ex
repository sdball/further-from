defmodule FurtherFrom.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    FurtherFrom.Release.migrate()
    children = [
      # Start the Telemetry supervisor
      FurtherFromWeb.Telemetry,
      # Start the Ecto repository
      FurtherFrom.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: FurtherFrom.PubSub},
      # Start Finch
      {Finch, name: FurtherFrom.Finch},
      # Start the Endpoint (http/https)
      FurtherFromWeb.Endpoint,
      {Task.Supervisor, name: FurtherFrom.TaskSupervisor}
      # Start a worker by calling: FurtherFrom.Worker.start_link(arg)
      # {FurtherFrom.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FurtherFrom.Supervisor]
    return = Supervisor.start_link(children, opts)
    Task.Supervisor.start_child(FurtherFrom.TaskSupervisor, FurtherFrom.DataSetup, :init, [])
    return
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FurtherFromWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
