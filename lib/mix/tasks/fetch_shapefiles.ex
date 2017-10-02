defmodule Mix.Tasks.FetchShapefiles do
  use Mix.Task

  def run(_) do 

    HTTPoison.start

    shapefile_url = "https://raw.githubusercontent.com/kgjenkins/ophz/master/shp/ophz.shp"
    dbf_url = "https://raw.githubusercontent.com/kgjenkins/ophz/master/shp/ophz.dbf"

    shapefile_path = "data/ophz.shp"
    dbf_path = "data/ophz.dbf"

    File.rm_rf("data")
    File.mkdir("data")

    {:ok, %{body: body}} = HTTPoison.get(shapefile_url)
    {:ok, shp} = File.open(shapefile_path, [:write])
    IO.binwrite(shp, body)
    File.close(shp)

    {:ok, %{body: body}} = HTTPoison.get(dbf_url)
    {:ok, dbf} = File.open(dbf_path, [:write])
    IO.binwrite(dbf, body)
    File.close(dbf)

  end
end
