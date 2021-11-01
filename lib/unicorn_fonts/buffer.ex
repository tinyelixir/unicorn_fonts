defmodule UnicornFonts.Buffer do
  use GenServer

  alias UnicornFonts.{BasicFont, Frame}

  require Logger

  # def start_link do
  #   Neopixel.start_link([pin: 18, count: 32])
  # end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    {:ok, []}
  end

  def set_message(message, pid \\ __MODULE__) do
    GenServer.call(pid, {:set_message, message})
  end

  def next_frame(pid \\ __MODULE__) do
    GenServer.call(pid, :next_frame)
  end

  def handle_call({:set_message, message}, _from, _state) do
    rows = BasicFont.string_to_pixels(message)
    initial_frame = %Frame{pixels: List.flatten(Enum.take(rows, 4))}

    frames =
      rows
      |> Enum.drop(4)
      |> Enum.reduce([initial_frame], fn(row, frames = [head | _]) -> [ Frame.shift(head, row) | frames] end)
    |> Enum.reverse()

    {:reply, :ok, frames}
  end

  def handle_call(:next_frame, _from, []), do: {:reply, nil, []}
  def handle_call(:next_frame, _from, [next | rest]) do
    {:reply, next, rest}
  end

  # @channel 0
  # def render(intensity, frame = %Frame{}) do
  #   Neopixel.render(@channel, {intensity, frame.pixels})
  # end
end
