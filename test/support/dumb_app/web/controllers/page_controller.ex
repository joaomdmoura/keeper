defmodule DumbApp.PageController do
  use DumbApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
