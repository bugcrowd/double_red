defmodule DoubleRed.LocationController do
  use DoubleRed.Web, :controller

  alias DoubleRed.Location

  def index(conn, _params) do
    locations = Repo.all(from Location, order_by: [desc: :inserted_at])

    render conn, "index.json", locations: locations
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.json", location: Repo.get!(Location, id)
  end

  def create(conn, %{"location" => location_params}) do
    changeset = Location.changeset(%Location{}, location_params)

    case Repo.insert(changeset) do
      {:ok, location} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", location_path(conn, :show, location))
        |> render("show.json", location: location)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoubleRed.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
