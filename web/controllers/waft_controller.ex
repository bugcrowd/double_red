defmodule DoubleRed.WaftController do
  use DoubleRed.Web, :controller

  alias DoubleRed.Waft

  def index(conn, _params) do
    wafts = Repo.all(Waft)
    render(conn, "index.json", wafts: wafts)
  end

  def create(conn, %{"waft" => waft_params}) do
    changeset = Waft.changeset(%Waft{}, waft_params)

    case Repo.insert(changeset) do
      {:ok, waft} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", waft_path(conn, :show, waft))
        |> render("show.json", waft: waft)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DoubleRed.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    waft = Repo.get!(Waft, id)
    render(conn, "show.json", waft: waft)
  end

  def update(conn, %{"id" => id, "waft" => waft_params}) do
    waft = Repo.get!(Waft, id)
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
    waft = Repo.get!(Waft, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(waft)

    send_resp(conn, :no_content, "")
  end
end
