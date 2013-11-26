# This is the skyportapi module.
# The module implements an API that communicates with the
# [Skyport](https://github.com/Amadiro/Skyport-logic) server.
# It acts as a wrapper for the [Skyport Protocol](
#  https://github.com/Amadiro/Skyport-logic/blob/master/docs/en/PROTOCOL.md)
# through the SkyportAPI class.


# Import `Connection` and `GameState` classes.
Connection = require("./skyportconnection")
GameState = require "./gamestate"


# Wrapper class for the [Skyport Protocol](
#  https://github.com/Amadiro/Skyport-logic/blob/master/docs/en/PROTOCOL.md).
# The class uses a dispatch table to call the appropriate functions in a Skyport
# AI implementation. The SkyportAPI class also maintain a gamestate that is
# updated whenever the server sends a new gamestate.
class SkyportAPI

  # SkyportAPI constructor method.
  # Construct a new SkyportAPI instance with a name and an empty dispatch table,
  # and create a new connection.
  constructor: (@name) ->
    @dispatchTable = {}
    @gamestate = null
    @connection = new Connection "localhost", 54321, this

  # Connect to skyport logic server.
  connect: () ->
    @connection.connect()

  # Add a signal and handler function to the dispatch table.
  on: (signal, handler) ->
    @dispatchTable[signal] = handler

  # Log an error to the console if an error is encountered.
  # The error object is sent by the Skyport server.
  error: (errorObject) ->
    console.log "Error occurred."
    console.log JSON.stringify errorObject

  # Send a handshake message to the server with the name of our bot.
  sendHandshake: (name) ->
    console.log "Send handshake to server"
    @connection.sendPacket
      "message": "connect"
      "revision": 1
      "name": name

  # Process a packet from the Skyport server.
  # Check the type of message received and then call
  # the respective function from the dispatch table.
  processPacket: (object) ->
    if object["error"]
      @dispatchTable["error"] object
    else
      switch object["message"]
        when "connect" then @dispatchTable["handshake"]()
        when "gamestate" then @processGameState object
        when "action" then @processAction object
  
  # Process the game state object received from the Skyport server.
  # If it is our first round create a `GameState` instance.
  # If it is a round > 0 update the game state (`@gamestate`).
  # Call appropriate function from dispatch table.
  processGameState: (object) ->
    if object["turn"] is 0
      @gamestate = new GameState object, @name
      @dispatchTable["gamestart"] @gamestate
    else
      @formatPositions object
      @gamestate.update object
      if @gamestate.isMyTurn()
        @dispatchTable["myturn"] @gamestate
      else
        @dispatchTable["gamestate"] @gamestate

  # Format the player positions received from server.
  # The original positions are on the form `position: "0,1"`.
  # Change format to `position: {j: 0, k: 0}`.
  formatPositions: (gamestate) ->
    for player in gamestate.players
      coordinates = player.position.split ", "
      player.position =
        j: coordinates[0]
        k: coordinates[1]

  # Process action received from server.
  # Determine if it is a player or bot action and call appropriate function
  # from `@dispatchTable`.
  # Possible actions are move, upgrade, mine, laser, mortar, droid.
  processAction: (object) ->
    from = object["from"]
    type = object["type"]
    delete object["from"]
    delete object["type"]

    if from == @name
      @dispatchTable["own_action"] type, object
    else
      @dispatchTable["action"] type, object, from

  # Send loadout to the Skyport server.
  sendLoadout: (primaryWeapon, secondaryWeapon) ->
    @connection.sendPacket
      "message": "loadout"
      "primary-weapon": primaryWeapon
      "secondary-weapon": secondaryWeapon

  # Send a move mesage to the Skyport server.
  move: (direction) ->
    @connection.sendPacket
      "message": "action"
      "type": "move"
      "direction": direction


# Export `SkyportAPI` class.
module.exports = SkyportAPI