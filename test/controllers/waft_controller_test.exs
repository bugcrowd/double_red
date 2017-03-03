defmodule DoubleRed.WaftControllerTest do
  use DoubleRed.ConnCase

  alias DoubleRed.Location
  alias DoubleRed.Waft

  @valid_attrs %{blue: 42, green: 42, brightness: 42, red: 42, temperature: 42}
  @invalid_attrs %{temperature: -1}

  setup %{conn: conn} do
    location_attrs  = %{name: "left", zone: 0}
    changeset       = Location.changeset(%Location{}, location_attrs)
    {:ok, location} = Repo.insert(changeset)
    conn = assign(conn, :location, location)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    location = conn.assigns.location
    conn = get conn, location_waft_path(conn, :index, location)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    location = conn.assigns.location
    waft =
      Ecto.build_assoc(location, :wafts)
      |> Waft.changeset(@valid_attrs)
      |> Repo.insert!

    conn = get conn, location_waft_path(conn, :show, location, waft)
    assert json_response(conn, 200)["data"] == %{"id" => waft.id,
      "temperature" => waft.temperature,
      "brightness" => waft.brightness,
      "red" => waft.red,
      "green" => waft.green,
      "blue" => waft.blue,
      "inserted_at" => to_string(waft.inserted_at)}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    location = conn.assigns.location
    assert_error_sent 404, fn ->
      get conn, location_waft_path(conn, :show, location, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    location = conn.assigns.location
    conn = post conn, location_waft_path(conn, :create, location), waft: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Waft, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    location = conn.assigns.location
    conn = post conn, location_waft_path(conn, :create, location), waft: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    location = conn.assigns.location
    waft =
      Ecto.build_assoc(location, :wafts)
      |> Waft.changeset(@valid_attrs)
      |> Repo.insert!

    conn = put conn, location_waft_path(conn, :update, location, waft), waft: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Waft, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    location = conn.assigns.location
    waft =
      Ecto.build_assoc(location, :wafts)
      |> Waft.changeset(@valid_attrs)
      |> Repo.insert!

    conn = put conn, location_waft_path(conn, :update, location, waft), waft: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    location = conn.assigns.location
    waft =
      Ecto.build_assoc(location, :wafts)
      |> Waft.changeset(@valid_attrs)
      |> Repo.insert!

    conn = delete conn, location_waft_path(conn, :delete, location, waft)
    assert response(conn, 204)
    refute Repo.get(Waft, waft.id)
  end
end
