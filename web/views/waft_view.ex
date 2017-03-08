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
      battery_percentage: waft.battery_percentage,
      battery_adc_level: waft.battery_adc_level,
      wifi_rssi: waft.wifi_rssi,
      inserted_at: to_string(waft.inserted_at)}
  end
end
