defmodule DoubleRed.Status do
  @moduledoc """
  Provides functions for determining occupancy status, based on Waft data.
  """

  import Ecto.Query, only: [from: 2]

  alias DoubleRed.Location
  alias DoubleRed.Repo

  defmodule NoWaftDataError do
    defexception message: "No waft data is available"
  end

  @doc """
  Indicates whether the most recent two wafts have different occupied statuses.

  Used for determining whether to change the presence status on Slack.
  """
  def changed?(location) do
    wafts = Ecto.assoc(location, :wafts)
      |> Repo.all(order_by: [desc: :inserted_at], limit: 2)

    # TODO: there has to be a cuter way to do this
    changed? List.first(wafts), List.last(wafts)
  end

  def changed?(waft1, waft2) do
    occupied?(waft1) != occupied?(waft2)
  rescue
    NoWaftDataError -> true
  end

  @doc """
  Get the current occupancy status for all zones.
  """
  def now do
    Repo.all(from l in Location, order_by: [desc: :inserted_at])
      |> Enum.map(fn(location) -> %{location.id => %{ status: now(location), name: location.name }} end)
      |> Enum.reduce(%{}, fn(status, acc) -> Map.merge(acc, status) end)
  end

  @doc """
  Get the current occupancy status for selected zone.
  """
  def now_by_zone(zone) do
    Repo.all(from l in Location, order_by: [desc: :inserted_at], where: l.zone == ^zone)
      |> Enum.map(fn(location) -> %{location.id => %{ status: now(location), name: location.name }} end)
      |> Enum.reduce(%{}, fn(status, acc) -> Map.merge(acc, status) end)
  end

  @doc """
  Get the current occupancy status for a given location.

  There's only one location at the moment, so it's not super interesting.
  """
  def now(location) do
    waft = Repo.one(from Ecto.assoc(location, :wafts), order_by: [desc: :inserted_at], limit: 1)
    occupied?(waft)
  rescue
    NoWaftDataError -> nil
  end

  @doc """
  Indicates whether a given waft means that a location is occupied
  (i.e., that it's "red").
  """
  def occupied?(nil), do: raise NoWaftDataError
  def occupied?(waft) do
    waft.red > waft.green * 1.2
  end
end
