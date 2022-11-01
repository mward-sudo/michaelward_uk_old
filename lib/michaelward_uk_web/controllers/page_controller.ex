defmodule MichaelwardUkWeb.PageController do
  use MichaelwardUkWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
