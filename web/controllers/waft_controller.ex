defmodule DoubleRed.WaftController do
  use DoubleRed.Web, :controller

  alias DoubleRed.Waft
  alias DoubleRed.Location
  alias DoubleRed.Status

  plug :find_location

  defp find_location(conn, _opts) do
    conn
    |> assign(:location, Repo.get!(Location, conn.params["location_id"]))
  end

  def index(conn, _params) do
    wafts =
      conn.assigns[:location]
      |> assoc(:wafts)
      |> Repo.all(order_by: [desc: :inserted_at])

    render(conn, "index.json", wafts: wafts)
  end

  def create(conn, %{"waft" => waft_params}) do
    location = conn.assigns.location
    changeset =
      location
        |> Ecto.build_assoc(:wafts)
        |> Waft.changeset(waft_params)

    case Repo.insert(changeset) do
      {:ok, waft} ->
        GenServer.cast(
          DoubleRed.SlackPresence,
          {:update, Status.occupied?(waft)}
        )

        conn
        |> put_status(:created)
        |> put_resp_header("location", location_waft_path(conn, :show, location, waft))
        |> render("show.json", waft: waft)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoubleRed.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    waft =
      conn.assigns[:location]
      |> assoc(:wafts)
      |> Repo.get(id)
    render(conn, "show.json", waft: waft)
  end

  def update(conn, %{"id" => id, "waft" => waft_params}) do
    waft =
      conn.assigns[:location]
      |> assoc(:wafts)
      |> Repo.get(id)
    changeset = Waft.changeset(waft, waft_params)

    case Repo.update(changeset) do
      {:ok, waft} ->
        render(conn, "show.json", waft: waft)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoubleRed.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    waft =
      conn.assigns[:location]
      |> assoc(:wafts)
      |> Repo.get(id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(waft)

    send_resp(conn, :no_content, "")
  end
end
