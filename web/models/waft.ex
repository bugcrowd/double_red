defmodule DoubleRed.Waft do
  @moduledoc """
  A Waft is a single reading from the DoubleRed hardware sensor.

  The sensor provides red, green and blue color values, as well as color
  temperature (kelvin) and brightness (lumens) readings.
  """

  use DoubleRed.Web, :model

  schema "wafts" do
    field :temperature, :integer
    field :brightness, :integer
    field :red, :integer
    field :green, :integer
    field :blue, :integer
    field :battery_adc_level, :integer
    field :battery_percentage, :integer
    field :wifi_rssi, :integer

    belongs_to :location, DoubleRed.Location
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:temperature, :brightness, :red, :green, :blue])
    |> validate_required([:temperature, :brightness, :red, :green, :blue])
    |> check_constraint(:temperature, name: :positive_temperature,
      message: "temperature must be at least 0"
    )
    |> check_constraint(:temperature, name: :valid_temperature,
      message: "temperature must be below 65536"
    )
    |> check_constraint(:brightness, name: :positive_brightness,
      message: "brightness must be at least 0"
    )
    |> check_constraint(:brightness, name: :valid_brightness,
      message: "brightness must be below 65536"
    )
    |> check_constraint(:red, name: :positive_red,
      message: "red must be at least 0"
    )
    |> check_constraint(:red, name: :valid_red,
      message: "red must be below 65536"
    )
    |> check_constraint(:green, name: :positive_green,
      message: "green must be at least 0"
    )
    |> check_constraint(:green, name: :valid_green,
      message: "green must be below 65536"
    )
    |> check_constraint(:blue, name: :positive_blue,
      message: "blue must be at least 0"
    )
    |> check_constraint(:blue, name: :valid_blue,
      message: "blue must be below 65536"
    )
  end
end
