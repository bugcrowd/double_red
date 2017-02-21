defmodule DoubleRed.StatusControllerTest do
  use DoubleRed.ConnCase

  alias DoubleRed.Waft
  alias DoubleRed.Repo

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "shows correct response with no waft data", %{conn: conn} do
    conn = get conn, status_path(conn, :show)
    assert json_response(conn, 200)["data"] == [%{
      "location" => 0,
      "occupied" => nil
    }]
  end

  test "shows correct response when occupied", %{conn: conn} do
    # someone shold really deduplicate these inserts
    Repo.insert! Waft.changeset(%Waft{}, %{
      brightness: 0,
      temperature: 0,
      red: 65535,
      green: 0,
      blue: 0
    })

    conn = get conn, status_path(conn, :show)
    assert json_response(conn, 200)["data"] == [%{
      "location" => 0,
      "occupied" => true
    }]
  end

  test "shows correct response when unoccupied", %{conn: conn} do
    Repo.insert! Waft.changeset(%Waft{}, %{
      brightness: 0,
      temperature: 0,
      red: 0,
      green: 0,
      blue: 0
    })

    conn = get conn, status_path(conn, :show)
    assert json_response(conn, 200)["data"] == [%{
      "location" => 0,
      "occupied" => false
    }]
  end
end
