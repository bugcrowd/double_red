defmodule DoubleRed.LocationController do
  use DoubleRed.Web, :controller

  alias DoubleRed.Location

  def index(conn, _params) do
    locations = Repo.all(from Location, order_by: [desc: :inserted_at])

    render(conn, "index.json", locations: locations)
  end
end
