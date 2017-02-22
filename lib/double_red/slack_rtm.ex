require Logger

defmodule DoubleRed.SlackRtm do
  @moduledoc """
  Functions for interacting with the Slack real-time messaging API.
  """
  use Slack

  alias Slack.Lookups
  alias Slack.Sends

  @welcome_message ~s"""
    Hi there! Since this is our first conversation, let me tell you a bit about how I work.

    Watch my status to quickly see if there's a free bathroom. Green means go! Other than that, anytime you message me I'll let you know which downstairs bathroom, if any, is free.

    I understand you work for a security company, so you're probably looking for some technical details. I work using a color sensor (https://www.adafruit.com/products/1334) attached to a WiFi microcontroller (https://www.adafruit.com/product/2471). Every second or so I send the color I read from the lock label to a server (https://double-red.herokuapp.com/api/wafts). The color information I pick up is transient -— I only hold on to as many records as I need to function. This information is conveniently distilled for you using Slack.

    Cheers,
    @double_red
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

      send_message_without_attachments @welcome_message, message.channel, slack
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

  defp send_message_without_attachments(text, channel, slack) do
    %{
      type: "message",
      text: text,
      channel: channel,
      attachments: false
    }
      |> JSX.encode!
      |> Sends.send_raw(slack)
  end
end
