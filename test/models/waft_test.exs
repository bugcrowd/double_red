defmodule DoubleRed.WaftTest do
  use DoubleRed.ModelCase

  alias DoubleRed.Waft

  @valid_attrs %{blue: 42, green: 42, brightness: 42, red: 42, temperature: 42}
  @invalid_attrs %{blue: -1, green: -1, brightness: -1, red: -1, temperature: -1}
  @missing_attrs %{}

  test "changeset with valid attributes" do
    changeset = Waft.changeset(%Waft{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    # these are enforced by check constraints, so just check that the
    # insert doesn't happen
    changeset = Waft.changeset(%Waft{}, @invalid_attrs)
    assert {:error, _} = Repo.insert(changeset)
  end

  test "changeset with missing attributes" do
    changeset = Waft.changeset(%Waft{}, @missing_attrs)
    refute changeset.valid?
  end
end
