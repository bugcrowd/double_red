defmodule DoubleRed.StatusTest do
  use DoubleRed.ModelCase

  alias DoubleRed.Status
  alias DoubleRed.Location
  alias DoubleRed.Waft

  test "#occupied? with red more than 20% greater than green returns true" do
    waft = %Waft{red: 12001, green: 10000}

    assert Status.occupied?(waft)
  end

  test "#occupied? with red less than or equal to 20% greater than green returns false" do
    waft = %Waft{red: 12000, green: 10000}

    refute Status.occupied?(waft)
  end

  test "#occupied? with a greener waft returns false" do
    waft = %Waft{red: 10000, green: 10001}

    refute Status.occupied?(waft)
  end

  test "#occupied? raises NoWaftDataError when no data is available" do
    assert_raise Status.NoWaftDataError, fn ->
      Status.occupied?(nil)
    end
  end

  test "#changed? when occupied?() has changed returns true" do
    waft1 = %Waft{red: 12001, green: 10000}
    waft2 = %Waft{red: 12000, green: 10000}
    assert Status.changed?(waft1, waft2)
  end

  test "#changed? when occupied?() has not changed returns false" do
    waft1 = %Waft{red: 12001, green: 10000}
    waft2 = %Waft{red: 12001, green: 10000}
    refute Status.changed?(waft1, waft2)
  end

  test "changed? with only one waft returns true" do
    waft1 = %Waft{red: 12001, green: 10000}
    assert Status.changed?(waft1, nil)
  end

  test "#now returns correct response with no waft data" do
    assert Status.now == %{}
  end

  test "#now returns occupied status for all locations, when occupied" do
    location = Location.changeset(%Location{}, %{name: "left", zone: 0})
      |> Repo.insert!

    Ecto.build_assoc(location, :wafts)
    |> Waft.changeset(%{temperature: 0, brightness: 0, red: 12001, green: 10000, blue: 0})
    |> Repo.insert!

    assert Status.now == %{location.id => %{name: "left", status: true}}
  end

  test "#now returns occupied status for all locations, when unoccupied" do
    location = Location.changeset(%Location{}, %{name: "left", zone: 0})
      |> Repo.insert!

    Ecto.build_assoc(location, :wafts)
    |> Waft.changeset(%{temperature: 0, brightness: 0, red: 12000, green: 10000, blue: 0})
    |> Repo.insert!

    assert Status.now == %{location.id => %{name: "left", status: false}}
  end
end
