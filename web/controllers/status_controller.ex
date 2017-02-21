defmodule DoubleRed.StatusController do
  use DoubleRed.Web, :controller

  alias DoubleRed.Status

  def show(conn, _params) do
    status = Status.now

    render(conn, "show.json", status: Status.now)
  end
end
