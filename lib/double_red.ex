defmodule DoubleRed do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(DoubleRed.Repo, []),
      supervisor(DoubleRed.Endpoint, []),
      worker(DoubleRed.SlackPresence, [])
    ]

    # Don't start the Slack.Bot app in test since it keeps a persistent
    # websocket connection
    children = children ++ (unless Mix.env == :test do
        [worker(Slack.Bot, [
          DoubleRed.SlackRtm,
          [],
          Application.get_env(:slack, :api_token),
          %{name: :slack}
        ])]
      else
        []
      end)

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DoubleRed.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DoubleRed.Endpoint.config_change(changed, removed)
    :ok
  end
end
