defmodule Hearty.Shapefiles do

  alias Hearty.Shapefiles

  def start_link do
    Shapefiles.Server.start_link(
      Application.get_env(:hearty, Hearty.Shapefiles)[:provider],
      Application.get_env(:hearty, Hearty.Shapefiles)[:shapefile],
      Application.get_env(:hearty, Hearty.Shapefiles)[:dbf]
    )
  end

  def query(lat, lng), do: Shapefiles.Server.query(lat, lng)

end
