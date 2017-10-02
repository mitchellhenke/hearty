defmodule HeartyWeb.PageController do
  use HeartyWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def query(conn, %{"latitude" => latitude, "longitude" => longitude}) do
    {lat, _} = Float.parse(latitude)
    {lng, _} = Float.parse(longitude)
    json(conn, %{
      zone: Hearty.Shapefiles.query(lat, lng),
      latitude: lat,
      longitude: lng
    })
  end
end
