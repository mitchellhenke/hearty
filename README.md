# Hearty

An API for getting the heartiness zone of a latitude and longitude point.

### Getting Started

```
git clone https://github.com/nickgartmann/hearty.git
cd hearty
mix do deps.get, deps.compile
mix fetch_shapefiles # Fetches the latest shapefiles from https://github.com/kgjenkins/ophz
mix phx.server
```

### API

```
GET /api/:latitude/:longitude
```

```
GET /api/43.0389/-87.9065

{
  "zone": "5b",
  "longitude": 43.0389,
  "latitude": -87.9065
}
```

