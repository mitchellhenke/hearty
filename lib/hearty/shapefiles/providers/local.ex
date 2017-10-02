defmodule Hearty.Shapefiles.Providers.Local do 

  def shapefile(path) do
    Exshape.Shp.read(File.stream!(path, [], 2048))
  end

  def dbf(path) do 
    Exshape.Dbf.read(File.stream!(path, [], 2048))  
  end

end
