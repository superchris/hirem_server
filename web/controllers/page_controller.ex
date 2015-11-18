defmodule Hirem.PageController do
  use Hirem.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
