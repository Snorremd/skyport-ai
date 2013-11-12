###
# Skyport API module
This module implements an API that communicates with the
[Skyport](https://github.com/Amadiro/Skyport-logic) server.
It acts as a wrapper for the [Skyport Protocol]
(https://github.com/Amadiro/Skyport-logic/blob/master/docs/en/PROTOCOL.md)
through the SkyportAPI class.
###

Connection = require("./skyportconnection")
GameState = require "./gamestate"

class SkyportAPI
  ###
  Wrapper class for the [Skyport Protocol]
  (https://github.com/Amadiro/Skyport-logic/blob/master/docs/en/PROTOCOL.md).
  The class uses a dispatchtable to call the appropriate functions in a Skyport
  AI implementation. The SkyportAPI class also maintain a gamestate that is
  updated when the server sends a new gamestate.
  ###

  constructor: (@name) ->
    ###
    Construct a new SkyportAPI instance with a name, an empty dispatch table,
    and create a new connection.
    ###
    @dispatchTable = {}
    @gamestate = null

    @connection = new Connection "localhost", 54321, this

  connect: () ->
    ### Public: Connect to skyport logic server. ###
    @connection.connect()

  on: (signal, handler) ->
    ###
    Public: Add a signal and handler method from ai class
    to dispatch table.
    ###
    @dispatchTable[signal] = handler

  error: (errorObject) ->
    ### Private: Called when connection encounters an error ###
    console.log "Error occurred."
    console.log JSON.stringify errorObject

  sendHandshake: (name) ->
    ### Public: Send handshake to server with name of bot. ###
    console.log "Send handshake to server"
    @connection.sendPacket
      "message": "connect"
      "revision": 1
      "name": name

  processPacket: (object) ->
    ###
    Private: Check type of Skyport message and call corresponding
    function in the dispatch table.
    ###
    if object["error"]
      @dispatchTable["error"]()
    else
      switch object["message"]
        when "connect" then @dispatchTable["handshake"]()
        when "gamestate" then @processGameState object
        when "action" then @processGameState object
         
  processGameState: (object) ->
    ###
    Private: Process game state object sent by Skyport server.
    Save or update game state instance with new data.
    Call appropriate function in the dispatch table.
    ###
    if object["turn"] is 0
      @gamestate = new GameState object
      @dispatchTable["gamestart"] object
    else
      @gamestate.update object
      @dispatchTable["gamestate"] object

  processAction: (object) ->
    ###
    Private: Process action received from server.
    Possible actions are move, upgrade, mine, laser, mortar, droid.
    Determines if it is an enemy action or player action.
    ###
    from = object["from"]
    type = object["type"]
    delete object["from"]
    delete object["type"]

    if from == player
      @dispatchTable["own_action"] type, object
    else
      @dispatchTable["action"] type, object, from

  sendLoadout: (primaryWeapon, secondaryWeapon) ->
    ### Public: Send loadout to server. ###
    console.log "Send loadout"
    @connection.sendPacket
      "message": "loadout"
      "primary-weapon": primaryWeapon
      "secondary-weapon": secondaryWeapon

module.exports = SkyportAPI