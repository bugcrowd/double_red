defmodule DoubleRed.StatusTest do
  use DoubleRed.ModelCase

  alias DoubleRed.Status
  alias DoubleRed.Waft

  test "#occupied? with a 'red' waft returns true" do
    waft = %Waft{red: 65535}

    assert Status.occupied?(waft)
  end

  test "#occupied? with a non-'red' waft returns false" do
    waft = %Waft{red: 0}

    refute Status.occupied?(waft)
  end

  test "#occupied? raises NoWaftDataError when no data is available" do
    assert_raise Status.NoWaftDataError, fn ->
      Status.occupied?(nil)
    end
  end

  test "#changed? when occupied?() has changed returns true" do
    assert Status.changed?(%Waft{red: 0}, %Waft{red: 65535})
  end

  test "#changed? when occupied?() has not changed returns false" do
    refute Status.changed?(%Waft{red: 0}, %Waft{red: 0})
  end

  test "changed? with only one waft returns true" do
    assert Status.changed?(%Waft{red: 0}, nil)
  end

  test "#now returns correct response with no waft data" do
    assert %{0 => nil} = Status.now
  end

  test "#now returns occupied status for all locations, when occupied" do
    Repo.insert! Waft.changeset(%Waft{}, %{
      temperature: 0,
      brightness: 0,
      red: 65535,
      green: 0,
      blue: 0
    })

    # `0` is the fake location identifier, since we only have one
    # location for now
    assert %{0 => true} = Status.now
  end

  test "#now returns occupied status for all locations, when unoccupied" do
    Repo.insert! Waft.changeset(%Waft{}, %{
      temperature: 0,
      brightness: 0,
      red: 0,
      green: 0,
      blue: 0
    })

    # `0` is the fake location identifier, since we only have one
    # location for now
    assert %{0 => false} = Status.now
  end
end
