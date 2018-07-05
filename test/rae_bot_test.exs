defmodule RaeBotTest do
  use ExUnit.Case
  doctest RaeBot

  test "greets the world" do
    assert RaeBot.hello() == :world
  end
end
