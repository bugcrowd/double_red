defmodule DoubleRed.Location do
  use DoubleRed.Web, :model

  schema "locations" do
    field :name, :string
    field :zone, :integer

    has_many :wafts, DoubleRed.Waft
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :zone])
    |> validate_required([:name, :zone])
  end
end
