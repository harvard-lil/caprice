defmodule CapriceWeb.Router do
  use CapriceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :xml_api do
    plug :accepts, ["html"]
  end

  pipeline :json_api do
    plug :accepts, ["json"]
  end

  scope "/", CapriceWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/viewer", CapriceWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :viewer
  end

  scope "/chat", CapriceWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :chat
  end

  scope "/xml", CapriceWeb do
    pipe_through :xml_api # Use the default browser stack

    get "/:barcode/:leaf_no/:page_side", CaselawController, :page_xml
    get "/:barcode/:case_no", CaselawController, :case_xml
    get "/:barcode", CaselawController, :volume_xml
  end

  scope "/metadata", CapriceWeb do
    pipe_through :json_api # Use the default browser stack

    get "/:barcode/:leaf_no/:page_side", CaselawController, :case_list_for_page
    get "/:barcode/:case_no", CaselawController, :case_pages
    get "/:barcode", CaselawController, :volume_contents
    get "/", CaselawController, :volume_list
  end

  scope "/admin", CapriceWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
  # Other scopes may use custom stacks.
  # scope "/api", CapriceWeb do
  #   pipe_through :api
  # end
end
