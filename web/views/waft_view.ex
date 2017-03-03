defmodule DoubleRed.WaftView do
  use DoubleRed.Web, :view

  def render("index.json", %{wafts: wafts}) do
    %{data: render_many(wafts, DoubleRed.WaftView, "waft.json")}
  end

  def render("show.json", %{waft: waft}) do
    %{data: render_one(waft, DoubleRed.WaftView, "waft.json")}
  end

  def render("waft.json", %{waft: waft}) do
    %{id: waft.id,
      temperature: waft.temperature,
      brightness: waft.brightness,
      red: waft.red,
      green: waft.green,
      blue: waft.blue,
      inserted_at: to_string(waft.inserted_at)}
  end
end
