defmodule AuthrUno.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      AuthrUno.Repo,
      # Start the Telemetry supervisor
      AuthrUnoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AuthrUno.PubSub},
      # Start the Endpoint (http/https)
      AuthrUnoWeb.Endpoint
      # Start a worker by calling: AuthrUno.Worker.start_link(arg)
      # {AuthrUno.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthrUno.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthrUnoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
