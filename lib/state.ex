defmodule ToyRobot.State do
  @moduledoc """
  Struct to hold Robot's position and direction state
  """

  defstruct x: nil, y: nil, direction: nil, was_placed: false
end
