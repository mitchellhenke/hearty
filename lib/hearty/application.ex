defmodule Hearty.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    shapeurl = "https://raw.githubusercontent.com/kgjenkins/ophz/master/shp/ophz.shp"
    dbfurl = "https://raw.githubusercontent.com/kgjenkins/ophz/master/shp/ophz.dbf"

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Hearty.Repo, []),
      # Start the endpoint when the application starts
      supervisor(HeartyWeb.Endpoint, []),
      worker(Hearty.ShapeServer, [
        Application.get_env(:hearty, Hearty.ShapeServer)[:provider],
        Application.get_env(:hearty, Hearty.ShapeServer)[:shapefile],
        Application.get_env(:hearty, Hearty.ShapeServer)[:dbf],
      ])
      # Start your own worker by calling: Hearty.Worker.start_link(arg1, arg2, arg3)
      # worker(Hearty.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hearty.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HeartyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
