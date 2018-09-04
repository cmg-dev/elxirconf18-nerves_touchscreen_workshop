defmodule NervesKiosk do
  require Logger

  @moduledoc """
  Documentation for NervesKiosk.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NervesKiosk.hello
      :world

  """
  def hello do
    Logger.debug("🎉 Hello")
    :world
  end
end
