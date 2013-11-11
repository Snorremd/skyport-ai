Map = require "./map"

class GameState

  constructor: (serverState, @myName) ->
    console.log "Create game state object"
    @map = new Map serverState.map
    @turn = 0
    @players = serverState.players
    console.log JSON.stringify this

  # Public: Updates game state
  update: (serverState) ->
    console.log "Update game state"
    @turn = serverState.turn
    @players = serverState.players

  # Public: Checks whether it is our turn
  isMyTurn: () ->
    if @players[0] is @myName then true else false

module.exports = GameState