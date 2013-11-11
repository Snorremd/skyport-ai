class Map

  constructor: (mapObject) ->
    console.log "Generate map"
    @jLength = mapObject["j-length"]
    @kLength = mapObject["k-length"]
    @mapData = @generateMap mapObject.data

  # Private: Generate map based on game map json arrays
  # Returns map data:
  # [
  #  [{k: 0, j: 0, value: "g"}, {...}],
  #  [{k:0, j: 1, value: "g"}, {...}],
  # ]
  generateMap: (map) ->
    mapData = []
    for jColumn in [0...@jLength]
      newColumn = []
      for kCell in [0...@kLength]
        cellObject =
          k: kCell
          j: jColumn
          value: map[jColumn][kCell]
        console.log cellObject
        newColumn.push cellObject
      mapData.push newColumn
    return mapData

module.exports = Map