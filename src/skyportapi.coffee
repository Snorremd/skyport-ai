Connection = require("./skyportconnection")

class SkyportAPI

  constructor: (@name) ->
    @dispatchTable = {}
    @connection = new Connection "localhost", 54321, this

  # Public: Connect to skyport logic server
  connect: () ->
    @connection.connect()

  # Public: Add a signal and handler method from ai class to dispatch table
  on: (signal, handler) ->
    @dispatchTable[signal] = handler

  # Private: Called when connection encounters an error
  error: (errorObject) ->
    console.log JSON.stringify errorObject

  # Public: Send handshake to server with name of bot
  sendHandshake: (name) ->
    console.log "Send handshake to server"
    @connection.sendPacket
      "message": "connect"
      "revision": 1
      "name": name

  processPacket: (object) ->
    console.log "Process packet"
    if object["error"]
      @dispatchTable["error"]()
    else
      switch object["message"]
        when "gamestate"
          if object["turn"] is 0
            @dispatchTable["gamestart"] object["map"], object["players"]

  sendLoadout: (weapon1, weapon2) ->
    @connection.sendPacket
      "message": "loadout"
      "primary-weapon": primary_weapon,
      "secondary-weapon": secondary_weapon



module.exports = SkyportAPI