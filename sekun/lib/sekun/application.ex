defmodule Sekun.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Sekun.Release

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Sekun.Repo,
      # Start the Telemetry supervisor
      SekunWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sekun.PubSub},
      # Start the Endpoint (http/https)
      SekunWeb.Endpoint
      # Start a worker by calling: Sekun.Worker.start_link(arg)
      # {Sekun.Worker, arg}
    ]

    # Hah lol
    if Application.get_env(:sekun, :env) == :prod do
      ecto_setup()
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sekun.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SekunWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end