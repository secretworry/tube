defmodule Tube.ContextTest do

  use ExUnit.Case, async: true

  alias Tube.Context
  import Tube.Context


  test "should assign if true" do
    assert assign(%Context{}, :key, :value, if: fn-> true end) == %Context{values: %{key: :value}, halted: false}
  end

  test "should not assign if false" do
    assert assign(%Context{}, :key, :value, if: fn-> false end) == %Context{values: %{}, halted: false}
  end

  test "should assign unless false" do
    assert assign(%Context{}, :key, :value, unless: fn-> false end) == %Context{values: %{key: :value}, halted: false}
  end

  test "should assign unless true" do
    assert assign(%Context{}, :key, :value, unless: fn-> true end) == %Context{values: %{}, halted: false}
  end
end
