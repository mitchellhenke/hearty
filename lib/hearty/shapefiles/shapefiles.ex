defmodule Hearty.Shapefiles do

  alias Hearty.Shapefiles

  def start_link do
    Shapefiles.Server.start_link(
      Application.get_env(:hearty, Hearty.Shapefiles)[:provider],
      Application.get_env(:hearty, Hearty.Shapefiles)[:shapefile],
      Application.get_env(:hearty, Hearty.Shapefiles)[:dbf]
    )
  end

  def query(latitude, longitude) do
    Shapefiles.Server.get()
    |> Enum.filter(fn({shape, _dbf}) -> 
      Map.has_key?(shape, :points)
    end)
    |> Enum.map(fn({shape, dbf}) -> 
      {
        shape,
        %{type: "Polygon", coordinates: [Enum.map(hd(shape.points), fn(%{x: x, y: y}) -> {x,y} end)]},
        %{type: "Polygon", coordinates: [[{shape.bbox.xmin,shape.bbox.ymin},{shape.bbox.xmin,shape.bbox.ymax},{shape.bbox.xmax,shape.bbox.ymax}, {shape.bbox.xmax,shape.bbox.ymin}]]},
        dbf
      }
    end)
    |> Enum.filter(fn({_shape, _, bbox,  _dbf}) ->
      Topo.contains?(bbox, %{type: "Point", coordinates: {latitude, longitude}})
    end)
    |> Enum.filter(fn({_shape, polygon, _bbox, _dbf}) ->
      Topo.contains?(polygon, %{type: "Point", coordinates: {latitude, longitude}})
    end)
    |> case do 
      [{_, _, _, [_, zone]} | _] -> zone
      _ -> nil
    end

  end

end
