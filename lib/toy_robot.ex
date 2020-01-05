defmodule ToyRobot do
  @moduledoc """
  Listens to stdin commands for a Toy Robot.
  """

  use Agent
  alias ToyRobot.{State, Command}

  @module __MODULE__

  @doc """
  Create a new robot state
  """
  def start_link() do
    Agent.start_link(fn -> %State{was_placed: false} end, name: @module)
  end

  def get_state do
    Agent.get(@module, & &1)
  end

  def do_update_state(state) do
    Agent.update(@module, &(&1 = state))
  end

  def update_state(x, y, direction, was_placed) do
    case was_placed do
      true ->
        %State{x: x, y: y, direction: direction, was_placed: was_placed} |> do_update_state
      _ -> nil
    end
  end

  def action_command({cmd, params}) do
    {x, y, direction, was_placed} =
      get_state()
      |> Command.do_command(cmd, params)
    update_state(x, y, direction, was_placed)
  end

  def action_command(_) do
    #
  end

  @doc """
  Start listening for stdin
  """
  def listen do
    start_link()

    case IO.read(:stdio, :line) do
      :eof -> :ok
      {:error, reason} -> IO.puts "Error: #{reason}"
      line ->
        line
        |> String.trim
        |> Command.parse_input
        |> action_command
        listen()
    end
  end

  @doc """
  Hello world.

  ## Examples

      iex> ToyRobot.hello()
      :world

  """
  def hello do
    :world
  end
end

ToyRobot.listen()
