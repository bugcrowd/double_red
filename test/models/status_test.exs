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

  test "#now returns occupied status for all locations" do
    Repo.insert! Waft.changeset(%Waft{}, %{
      temperature: 0,
      brightness: 0,
      red: 0,
      green: 0,
      blue: 0
    })

    assert [false] = Status.now
  end
end
