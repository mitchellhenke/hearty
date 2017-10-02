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

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def handle_call(:get, _, state), do: {:reply, state, state}
end





