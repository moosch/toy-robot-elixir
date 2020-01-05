defmodule ToyRobotTest do
  use ExUnit.Case
  doctest ToyRobot.Command

  alias ToyRobot.Command

  describe "identify_command" do
    test "returns a tuple where the first element is the :move atom" do
      assert Command.identify_command("MOVE") == {:move, "MOVE"}
    end
  end

  # test "greets the world" do
  #   assert ToyRobot.hello() == :world
  # end
end
