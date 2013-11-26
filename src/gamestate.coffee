# GameState
# --------
# The gamestate module implements a `GameState` class that holds
# and updates the game state given by the Skyport Logic server.
Map = require "./map"

# The `GameState` class implements a model of the SkyPort
# game state.
# It contains a map, a turn counter and a list of players.
class GameState

  # Constructor method for the `GameState` class. Takes two parameters:
  # `serverState`, game state from Skyport Logic server; and
  # `myName`, name from `SkyportAPI` instance.
  constructor: (serverState, @myName) ->
    console.log "Create game state object"
    @map = new Map serverState.map
    @turn = 0
    @players = serverState.players
    this # Return instance once created

  # Update the stored game state with game state data from server.
  update: (serverState) ->
    console.log "Update game state"
    @turn = serverState.turn
    @players = serverState.players
    this # Return instance

  # Check if it is our turn. Returns a `boolean` value.
  isMyTurn: () ->
    if @players[0].name is @myName then true else false

# Export `GameState` class.
module.exports = GameState