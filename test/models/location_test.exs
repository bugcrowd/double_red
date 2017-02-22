defmodule DoubleRed.LocationTest do
  use DoubleRed.ModelCase

  alias DoubleRed.Location

  @valid_attrs %{name: "some content", zone: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Location.changeset(%Location{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.valid?
  end
end
