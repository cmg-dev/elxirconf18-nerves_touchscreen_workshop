defmodule PhxKiosk.Backlight do
  use GenServer

  @brightness_file "/sys/class/backlight/rpi_backlight/brightness"

  #  Public API {{{ #
  def start_link(options) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  def brightness(value) when value >= 0 and value < 256 do
    GenServer.call(__MODULE__, {:brightness, value})
  end

  def brightness(_) do
   {:error, "Value has to be [0,255]"}
  end

  def brightness() do
    GenServer.call(__MODULE__, :brightness)
  end
  #  }}} Public API #

  #  Callbacks {{{ #
  def init(_) do
    {:ok, 255}
  end

  def handle_call(:brightness, _from, brightness) do
    {:reply, brightness, brightness}
  end

  def handle_call({:brightness, value}, _, _) do
    if File.exists?(@brightness_file) do
      value = value |> round() |> to_string()
      File.write(@brightness_file, value)
    end

    {:reply, value, value}
  end
  #  }}} Callbacks #
end