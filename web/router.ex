defmodule DoubleRed.Router do
  use DoubleRed.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DoubleRed do
    pipe_through :api
  end
end
