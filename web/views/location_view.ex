defmodule DoubleRed.LocationView do
  use DoubleRed.Web, :view

  def render("index.json", %{locations: locations}) do
    %{data: render_many(locations, DoubleRed.LocationView, "location.json")}
  end

  def render("location.json", %{location: location}) do
    %{id: location.id,
      name: location.name,
      zone: location.zone}
  end
end
