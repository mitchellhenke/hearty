defmodule Hearty.Shapefiles.Server do
  use GenServer 

  def start_link(provider, shapefile_path, dbf_path) do

    zipped = Stream.zip(
      provider.shapefile(shapefile_path),
      provider.dbf(dbf_path)
    ) |> Enum.to_list

    IO.puts "Shapefiles parsed..."

    GenServer.start_link(__MODULE__, zipped, name: __MODULE__)
  end

  def query(latitude, longitude) do
    GenServer.call(__MODULE__, {:query, latitude, longitude})
  end

  def handle_call({:query, latitude, longitude}, _, state) do
    result = state
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

    case result do 
      [{_, _, _, [_, zone]} | _] -> {:reply, zone, state}
      _ -> {:reply, nil, state}
    end
    
  end

end





