defmodule CapriceWeb.PageController do
  use CapriceWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def chat(conn, _params) do
    render conn, "chat.html"
  end

  def viewer(conn, _params) do
    render conn, "viewer.html"
  end
end
