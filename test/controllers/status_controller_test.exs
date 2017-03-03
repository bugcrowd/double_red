defmodule DoubleRed.StatusControllerTest do
  use DoubleRed.ConnCase

  alias DoubleRed.Waft
  alias DoubleRed.Repo
  alias DoubleRed.Location

  setup %{conn: conn} do
    location_attrs  = %{name: "left", zone: 0}
    changeset       = Location.changeset(%Location{}, location_attrs)
    {:ok, location} = Repo.insert(changeset)
    conn = assign(conn, :location, location)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "shows correct response with no waft data", %{conn: conn} do
    location = conn.assigns.location
    conn = get conn, status_path(conn, :show)
    assert json_response(conn, 200)["data"] == [%{
      "location" => location.id,
      "occupied" => %{ "name" => "left", "status" => nil }
    }]
  end

  test "shows correct response when occupied", %{conn: conn} do
    location = conn.assigns.location

    waft =
      Ecto.build_assoc(location, :wafts)
      |> Waft.changeset(%{
        brightness: 0,
        temperature: 0,
        red: 65535,
        green: 0,
        blue: 0
      })
      |> Repo.insert!

    conn = get conn, status_path(conn, :show)
    assert json_response(conn, 200)["data"] == [%{
      "location" => location.id,
      "occupied" => %{ "name" => "left", "status" => true }
    }]
  end

  test "shows correct response when unoccupied", %{conn: conn} do
    location = conn.assigns.location

    waft =
      Ecto.build_assoc(location, :wafts)
      |> Waft.changeset(%{
        brightness: 0,
        temperature: 0,
        red: 0,
        green: 0,
        blue: 0
      })
      |> Repo.insert!

    conn = get conn, status_path(conn, :show)
    assert json_response(conn, 200)["data"] == [%{
      "location" => location.id,
      "occupied" => %{ "name" => "left", "status" => false }
    }]
  end
end
