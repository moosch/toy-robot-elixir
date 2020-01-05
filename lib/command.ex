defmodule ToyRobot.Command do

  alias ToyRobot.State

  @max 5
  @min 0
  @valid_commands [{~r/PLACE/, :place}, {~r/MOVE/, :move}, {~r/LEFT/, :left}, {~r/RIGHT/, :right}, {~r/REPORT/, :report}]

  def identify_command(input) do
    {_, command} = Enum.find(
      @valid_commands,
      {nil, :unknown},
      fn {reg, _} -> String.match?(input, reg) end
    )
   {command, input}
  end

  @doc """
  Turns the input into params if command is :place
  """
  def parse_command({:place, input}) do
    params =
      input
      |> String.split(" ", trim: true)
      |> List.last
      |> String.split(",", trim: true)

    case length(params) do
      3 ->
        [x, y, direction] = params
        {:place, %{ x: String.to_integer(x), y: String.to_integer(y), direction: direction}}

      _ -> {:unknown, input}
    end
  end
  def parse_command(input), do: input

  def parse_input(input) do
    input
    |> identify_command
    |> parse_command
  end

  # Any command without a PLACE first
  def do_command(%State{ x: x, y: y, direction: direction, was_placed: false}, cmd, _) when cmd != :place, do: {x, y, direction, false}

  # MOVE command
  def do_command(%State{x: x, y: y, direction: "NORTH", was_placed: was_placed}, :move, _) when x < @max, do: {x, y + 1, "NORTH", was_placed}
  def do_command(%State{x: x, y: y, direction: "SOUTH", was_placed: was_placed}, :move, _) when x > @min, do: {x, y - 1, "SOUTH", was_placed}
  def do_command(%State{x: x, y: y, direction: "EAST", was_placed: was_placed}, :move, _) when y < @max, do: {x + 1, y, "EAST", was_placed}
  def do_command(%State{x: x, y: y, direction: "WEST", was_placed: was_placed}, :move, _) when y > @min, do: {x - 1, y, "WEST", was_placed}

  # LEFT command
  def do_command(%State{x: x, y: y, direction: "NORTH", was_placed: was_placed}, :left, _), do: {x, y, "WEST", was_placed}
  def do_command(%State{x: x, y: y, direction: "SOUTH", was_placed: was_placed}, :left, _), do: {x, y, "EAST", was_placed}
  def do_command(%State{x: x, y: y, direction: "EAST", was_placed: was_placed}, :left, _), do: {x, y, "NORTH", was_placed}
  def do_command(%State{x: x, y: y, direction: "WEST", was_placed: was_placed}, :left, _), do: {x, y, "SOUTH", was_placed}
  # RIGHT command
  def do_command(%State{x: x, y: y, direction: "NORTH", was_placed: was_placed}, :right, _), do: {x, y, "EAST", was_placed}
  def do_command(%State{x: x, y: y, direction: "SOUTH", was_placed: was_placed}, :right, _), do: {x, y, "WEST", was_placed}
  def do_command(%State{x: x, y: y, direction: "EAST", was_placed: was_placed}, :right, _), do: {x, y, "SOUTH", was_placed}
  def do_command(%State{x: x, y: y, direction: "WEST", was_placed: was_placed}, :right, _), do: {x, y, "NORTH", was_placed}

  # REPORT command
  def do_command(%State{x: x, y: y, direction: direction, was_placed: true}, :report, _) do
    IO.write(:stdio, "#{x},#{y},#{direction}")
    {x, y, direction, true}
  end

  # PLACE command
  def do_command(_, :place, %{ x: x, y: y, direction: "NORTH"}) when x <= @max and x >= @min and y <= @max and y >= @min, do: {x, y, "NORTH", true}
  def do_command(_, :place, %{ x: x, y: y, direction: "SOUTH"}) when x <= @max and x >= @min and y <= @max and y >= @min, do: {x, y, "SOUTH", true}
  def do_command(_, :place, %{ x: x, y: y, direction: "EAST"}) when x <= @max and x >= @min and y <= @max and y >= @min, do: {x, y, "EAST", true}
  def do_command(_, :place, %{ x: x, y: y, direction: "WEST"}) when x <= @max and x >= @min and y <= @max and y >= @min, do: {x, y, "WEST", true}

  # Unknown command
  def do_command(state, _), do: {state.x, state.y, state.direction, state.was_placed}

end
