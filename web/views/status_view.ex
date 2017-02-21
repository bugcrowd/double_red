defmodule DoubleRed.StatusView do
  use DoubleRed.Web, :view

  def render("show.json", %{status: status}) do
    %{data: render_many(status, DoubleRed.StatusView, "status.json")}
  end

  def render("status.json", %{status: {location, occupied}}) do
    %{location: location,
      occupied: occupied}
  end
end
