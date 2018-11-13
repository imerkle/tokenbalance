defmodule TokenbalanceWeb.Router do
  use TokenbalanceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TokenbalanceWeb do
    pipe_through :api
    
    get "/balance", TokenController, :balance
  end
end
