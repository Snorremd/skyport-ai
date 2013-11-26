# The class Tile models a tile in the Skyport game.
# It has a `j` and `k` property specifying its coordinates.
# The `value` property specified which kind of tile it is,
# namely:
# possible types being:
# - "G" -- "GRASS"
# - "V" -- "VOID"
# - "S" -- "SPAWN"
# - "E" -- "EXPLOSIUM"
# - "R" -- "RUBIDIUM"
# - "C" -- "SCRAP"
# - "O" -- "ROCK"
class Tile

  # The constructor method for the tile class.
  constructor: (@j, @k, @value) ->

  # Find the distance between another tile and this tile.
  # Kindly borrowed from: [pilsprog skyport-api](
  #  https://github.com/pilsprog/skyport-api/tree/master/java).
  distance: (tile) ->
    updown = Math.abs tile.j - j
    diagonal = Math.abs tile.k - k
    leftright = Math.abs(tile.j - tile.k) * -1 - (j - k) * -1
    Math.max updown, Math.max diagonal, leftright

  # Find the direction of the given tile from this tile.
  # Possible return values: `"down", "left-down", "right-down",
  # "up", "right-up", "left-up", "none"`.
  # Kindly borrowed from: [pilsprog skyport-api](
  #  https://github.com/pilsprog/skyport-api/tree/master/java).
  direction: (tile) ->
    degrees = Math.round(
      Math.atan2(@j - tile.j, @k - tile.k) * 180 / Math.PI
    )

    console.log degrees

    switch degrees
      when -135 then "down"
      when -90 then "left-down"
      when 180 then "right-down"
      when 45 then "up"
      when 90 then "right-up"
      when 0 then "left-up"
      else "none"

# Export `Tile` class.
module.exports = Tile