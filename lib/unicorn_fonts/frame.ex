defmodule UnicornFonts.Frame do
  require Logger

  @unicorn_size 32

  defstruct pixels: (for _ <- 1..@unicorn_size, do: {0,0,0})

  def shift(frame = %__MODULE__{}, pixels) do
    %__MODULE__{pixels: Enum.drop(frame.pixels, length(pixels)) ++ pixels}
  end
end
