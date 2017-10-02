defmodule Hearty.Shapefiles.Providers.Remote do 

  def shapefile(path) do
    path
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> to_stream()
    |> Exshape.Shp.read()
  end

  def dbf(path) do
    path
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> to_stream()
    |> Exshape.Dbf.read()
  end

  defp to_stream(binary) do
    Stream.resource(
      fn -> binary end,
      fn bin -> 
        case bin do 
          :done -> {:halt, binary}
          _ -> {[binary], :done}
        end
      end,
      fn bin -> bin end
    )
  end
end
