defmodule DoubleRed.Waft do
  @moduledoc """
  A Waft is a single reading from the DoubleRed hardware sensor.

  The sensor provides red, green and blue color values, as well as color
  temperature and brightness (lumen) readings.
  """

  use DoubleRed.Web, :model

  schema "wafts" do
    field :temperature, :integer
    field :lumens, :integer
    field :red, :integer
    field :green, :integer
    field :blue, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:temperature, :lumens, :red, :green, :blue])
    |> validate_required([:temperature, :lumens, :red, :green, :blue])
    |> check_constraint(:temperature, name: :positive_temperature,
      message: "temperature must be positive"
    )
    |> check_constraint(:temperature, name: :valid_temperature,
      message: "temperature must be below 65536"
    )
    |> check_constraint(:lumens, name: :positive_lumens,
      message: "lumens must be positive"
    )
    |> check_constraint(:lumens, name: :valid_lumens,
      message: "lumens must be below 65536"
    )
    |> check_constraint(:red, name: :positive_red,
      message: "red must be positive"
    )
    |> check_constraint(:red, name: :valid_red,
      message: "red must be below 65536"
    )
    |> check_constraint(:green, name: :positive_green,
      message: "green must be positive"
    )
    |> check_constraint(:green, name: :valid_green,
      message: "green must be below 65536"
    )
    |> check_constraint(:blue, name: :positive_blue,
      message: "blue must be positive"
    )
    |> check_constraint(:blue, name: :valid_blue,
      message: "blue must be below 65536"
    )
  end
end
