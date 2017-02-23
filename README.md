# DoubleRed

API for collecting Double Red color sensor readings and interacting with Slack.

## Installation
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

## Usage

### Locations

A location represents a restroom or stall that can be occupied or unoccupied. Register a location with the API and you can begin updating the status of that location.

#### Create a location

```
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{
            "location": {
              "name": "Left Bathroom",
              "zone": 0
            }
          }' \
  https://bot.famo.io/api/locations
```

An example response from the locations index might be:

```
{
  "data": [
    {
      "zone": 0,
      "name": "Left Bathroom",
      "id": "33ac6da6-970e-4f3e-9be1-4189a3abd18b"
    },
    {
      "zone": 1,
      "name": "Right Bathroom",
      "id": "9901dbe5-2a1b-4abb-86d3-811a1a5abe26"
    }
  ]
}
```

### Wafts

A waft represents a status update for the location. At the moment double-red supports a color sensor for determining whether or not the restroom is occupied. When the color of the door indicator is red, that means the restroom is occupied. When the color is green the restroom is free for use.

To update the status of the restroom, post the details from the color sensor to that endpoint.


#### Create a Waft

In this example we'll update the status of the left bathroom from the above list. This is a contrived example of a red reading from the sensor, where red is maxed out and all other filtered colors are zero.

```
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{
            "waft": {
              "red": 65535,
              "green": 0,
              "blue": 0,
              "temperature": 0,
              "brightness": 0
            }
          }' \
  https://bot.famo.io/api/locations/33ac6da6-970e-4f3e-9be1-4189a3abd18b/wafts
```

### Query the Current Status

To get the current status of the locations, query the status endpoint.

```
curl https://bot.famo.io/api/status
```

This example response displays the left bathroom as occupied and the right as unoccupied:

```
{
  "data": [
    {
      "occupied": true,
      "location": "33ac6da6-970e-4f3e-9be1-4189a3abd18b"
    },
    {
      "occupied": false,
      "location": "9901dbe5-2a1b-4abb-86d3-811a1a5abe26"
    }
  ]
}
```
