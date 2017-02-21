defmodule DoubleRed.Status do
  @moduledoc """
  Provides functions for determining occupancy status, based on Waft data.
  """

  import Ecto.Query, only: [from: 2]

  alias DoubleRed.Repo
  alias DoubleRed.Waft

  defmodule NoWaftDataError do
    defexception message: "No waft data is available"
  end

  @doc """
  Indicates whether the most recent two wafts have different occupied statuses.

  Used for determining whether to change the presence status on Slack.
  """
  def changed? do
    wafts = Repo.all(
      from x in Waft,
      order_by: [desc: x.inserted_at],
      limit: 2
    )

    # TODO: there has to be a cuter way to do this
    changed? List.first(wafts), List.last(wafts)
  end

  def changed?(waft1, waft2) do
    occupied?(waft1) != occupied?(waft2)
  rescue
    NoWaftDataError -> true
  end

  @doc """
  Get the current occupancy status for all locations.
  """
  def now do
    locations = [0]

    locations
    |> Enum.map(fn(location_id) ->
      %{location_id => now(location_id)}
    end)
    |> Enum.reduce(%{}, fn(status, acc) ->
      Map.merge(acc, status)
    end)
  end

  @doc """
  Get the current occupancy status for a given location.

  There's only one location at the moment, so it's not super interesting.
  """
  def now(_location_id) do
    waft = Repo.one(from x in Waft, order_by: [desc: x.inserted_at], limit: 1)

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
    waft.red == 65535
  end
end
