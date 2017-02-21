defmodule DoubleRed.WaftControllerTest do
  use DoubleRed.ConnCase

  alias DoubleRed.Waft
  @valid_attrs %{blue: 42, green: 42, lumens: 42, red: 42, temperature: 42}
  @invalid_attrs %{temperature: -1}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, waft_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    waft = Repo.insert! Waft.changeset(%Waft{}, @valid_attrs)
    conn = get conn, waft_path(conn, :show, waft)
    assert json_response(conn, 200)["data"] == %{"id" => waft.id,
      "temperature" => waft.temperature,
      "lumens" => waft.lumens,
      "red" => waft.red,
      "green" => waft.green,
      "blue" => waft.blue}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, waft_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, waft_path(conn, :create), waft: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Waft, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, waft_path(conn, :create), waft: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    waft = Repo.insert! Waft.changeset(%Waft{}, @valid_attrs)
    conn = put conn, waft_path(conn, :update, waft), waft: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Waft, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    waft = Repo.insert! Waft.changeset(%Waft{}, @valid_attrs)
    conn = put conn, waft_path(conn, :update, waft), waft: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    waft = Repo.insert! Waft.changeset(%Waft{}, @valid_attrs)
    conn = delete conn, waft_path(conn, :delete, waft)
    assert response(conn, 204)
    refute Repo.get(Waft, waft.id)
  end
end
