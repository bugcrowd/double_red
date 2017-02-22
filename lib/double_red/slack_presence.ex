require Logger

defmodule DoubleRed.SlackPresence do
  @moduledoc """
  Server for updating the connected Slack bot's presence (online status) via
  the Slack web API.
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def handle_cast({:update, is_occupied}, _state) do
    Logger.debug "received :update with: #{is_occupied}"

    presence = if is_occupied do
      "away"
    else
      "active"
    end

    Slack.Web.Presence.set(presence)

    {:noreply, is_occupied}
  end
  def handle_cast(message, _), do: Logger.debug "other message received: #{message}"
end
