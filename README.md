# Toy Robot Simulator

A simple Elixir program to control a toy robot.

## Get started

Install dependencies with `mix deps.get`.

Then `iex -S mix` and paste your input followed by ⏎

### Examples

* Example a *

  PLACE 0,0,NORTH
  MOVE
  REPORT

Expected output:

  0,1,NORTH

* Example b *

  PLACE 0,0,NORTH
  LEFT
  REPORT

Expected output:

  0,0,WEST

* Example c *

  PLACE 1,2,EAST
  MOVE
  MOVE
  LEFT
  MOVE
  REPORT

Expected output

  3,3,NORTH
