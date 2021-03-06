require Logger

defmodule DoubleRed.SlackRtm do
  @moduledoc """
  Functions for interacting with the Slack real-time messaging API.
  """
  use Slack

  alias Slack.Lookups

  @welcome_message ~s"""
Hi there! Since this is our first conversation, let me tell you a bit about how I work.

Watch my status to quickly see if there's a free bathroom. Green means go! Other than that, anytime you message me I'll let you know which downstairs bathroom, if any, is free.

I understand you work for a security company, so you're probably looking for some technical details. I work using a color sensor (https://www.adafruit.com/products/1334) attached to a WiFi microcontroller (https://www.adafruit.com/product/2471). Every second or so I send the color I read from the lock label to a server (https://double-red.herokuapp.com/api/wafts). This information is conveniently distilled for you using Slack.

Cheers,
Double Red
"""

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    # Don't reply to our own messages or informational messages
    if Map.has_key?(message, :user) && message.user != slack.me.id do
      username = Lookups.lookup_user_name(message.user, slack)

      Logger.info "Sending the welcome message to #{username}"

      if String.downcase(message.text) == "status" do
        send_status message.channel
      else
        send_message @welcome_message, message.channel, slack
      end
    end

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  # Can't send attachments via the RTM API, so this uses the web API
  defp send_status(channel) do
    status = DoubleRed.Status.now_by_zone(0)

    message = "Here's the current status:"

    attachments = Enum.map(status, fn({id, location}) ->
      Logger.debug "#{id} is #{location[:status]}"

      {text, color} = case location[:status] do
        true ->  {":arrow_#{location[:name]}: Occupied :disappointed:", "#ff0000"}
        false -> {":arrow_#{location[:name]}: Unoccupied :smile:",      "#00ff00"}
        _ ->     {":arrow_#{location[:name]}: I'm not sure :confused:", "#cccccc"}
      end

      %{
        color: color,
        text: text
      }
    end)
    |> Poison.encode!

    Slack.Web.Chat.post_message channel, message, %{
      as_user: true,
      attachments: attachments
    }
  end
end
