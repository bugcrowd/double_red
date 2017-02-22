defmodule DoubleRed.Router do
  use DoubleRed.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DoubleRed do
    pipe_through :api

    resources "/locations", LocationController do
      resources "/wafts", WaftController, except: [:new, :edit]
    end
    resources "/status", StatusController, only: [:show], singleton: true
  end
end
