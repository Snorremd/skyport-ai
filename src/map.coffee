# Map
# ---
# The map module implements the `Map` class.

Tile = require "./tile"

# The `Map` class holds the game map and provides a set of
# helper methods to make reading the map easier. The map is
# derived from the map object received from the Skyport Logic server,
# but has coordinate values in each cell object in the mapData double array.
class Map

  @DIRECTIONS: ['up', 'down', 'right-up', 'right-down', 'left-up', 'left-down']

  # Constructor method for the `Map` class. The mapObject is given by
  # the Skyport Logic server and comes in the following form:
  # ```
  # "map": {"j-length": 5,
  #         "k-length": 5,
  #         data: [["R", "G", "V", "G", "V"],
  #                ["G", "E", "G", "G", "S"],
  #                ["G", "G", "O", "G", "G"],
  #                ["S", "G", "G", "C", "G"]
  #                ["V", "G", "V", "G", "G"]]
  #         }```
  constructor: (mapObject) ->
    console.log "Generate map"
    @jLength = mapObject["j-length"]
    @kLength = mapObject["k-length"]
    @mapData = @generateMap mapObject.data

  # Generate a map given `map` a double array of
  # map tile values as listed above. It loops through
  # each element in the inner arrays to create new cells.
  # It returns a double array of cells with added coordinate
  # values as listed below:
  # ```
  # [
  #   [{k: 0, j: 0, value: "R"}, {k: 0, j: 0, value: "G"}, ...],
  #   [{k: 0, j: 1, value: "G"}, {k: 1, j: 1, value: "E"}, ...],
  #   [...],
  #   [{k: 0, j: 4, value: "V"}, {k: 1, j: 4, value: "G"}, ...]
  # ]```
  generateMap: (map) ->
    mapData = []
    for j in [0...@jLength] # Exclusive
      column = []
      for k in [0...@kLength] # Exclusive
        tile = new Tile j, k, map[j][k]
        column.push tile
      mapData.push column
    return mapData

  # Get the value of a single cell given coordinates `j`, and `k`.
  getCellValue: (j, k) ->
    return @mapData[j][k].value


  # Get the neighbouring tile of a given `tile`.
  # All cells that are inside the game map are returned.
  neighbours: (tile) ->
    adjacentCoordinates = [
      [tile.j+1, tile.k+1]   # Down
      [tile.j+1, tile.k]     # left-down
      [tile.j, tile.k+1]     # right-down
      [tile.j-1, tile.k-1]   # up
      [tile.j-1, tile.k]     # right-up
      [tile.j, tile.k-1]     # left-up
    ]

    neighbours = []

    for [jAdj, kAdj] in adjacentCoordinates
      if @insideMap(jAdj, kAdj)
        neighbours.push @mapData[jAdj][kAdj]

    return neighbours

  # Check wether a coordinate is inside the game map.
  insideMap: (j, k) ->
    return 0 <= j < @jLength and 0 <= k < @kLength

  # Check wether it is permissible to move onto a cell.
  walkable: (j, k) ->
    if @mapData[j][k].value isnt "V" and
        @mapData[j][k].value isnt "O" and
        @mapData[j][k].value isnt "S"
      true
    else
      false

# Export `Map` class.
module.exports = Map
