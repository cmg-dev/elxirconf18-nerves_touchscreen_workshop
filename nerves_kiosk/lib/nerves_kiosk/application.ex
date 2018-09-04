defmodule NervesKiosk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategiering_loggers and supported options
    platform_init(@target)

    webengine_kiosk_opts =
      Application.get_all_env(:webengine_kiosk)

    children = [
      {WebengineKiosk, {webengine_kiosk_opts, [name: Display]}}
    | children(@target)]

    opts = [strategy: :one_for_one, name: NervesKiosk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children("host") do
    [
      # Starts a worker by calling: NervesKiosk.Worker.start_link(arg)
      # {NervesKiosk.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: NervesKiosk.Worker.start_link(arg)
      # {NervesKiosk.Worker, arg},
    ]
  end

  #  Add Webengine Stuff {{{ #
  defp platform_init("host") do
    :ok
  end

  defp platform_init(_target) do
    # Initialize udev
    :os.cmd('udevd -d')
    :os.cmd('udevadm trigger --type=subsystem --action=add')
    :os.cmd('udevadm trigger --type=devices --action=add')
    :os.cmd('udevadm settle --timeout=30')

    # Workaround a known bug with HTML5 canvas an RPI GPU
    System.put_env("QTWEBENGINE_CHROMIUM_FLAGS", "--disable-gpu")

    # Link to Console
    System.put_env("QTWEBENGINE_REMOTE_DEBUGGING", "9222")
    MuonTrap.Daemon.start_link("socat", ["tcp-listen:9223,fork",
                                        "tcp:localhost:9222"])
  end
  #  }}} Add Webengine Stuff #
end
