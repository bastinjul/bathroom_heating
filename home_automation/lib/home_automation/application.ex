defmodule HomeAutomation.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HomeAutomation.Repo,
      # Start the Telemetry supervisor
      HomeAutomationWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HomeAutomation.PubSub},
      # Start the Endpoint (http/https)
      HomeAutomationWeb.Endpoint,
      # Start a worker by calling: HomeAutomation.Worker.start_link(arg)
      # {HomeAutomation.Worker, arg}
      HomeAutomation.TemperaturePuller
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HomeAutomation.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HomeAutomationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
