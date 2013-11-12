SkyportAPI = require "./skyportapi"

class SimpleAI

  constructor: (@name) ->
    @api = new SkyportAPI @name
    @api.on "connection", @gotConnection
    @api.on "error", @gotError
    @api.on "handshake", @gotHandshake
    @api.on "gamestart", @gotGameStart
    @api.on "gamestate", @gotGameState
    @api.on "own_action", @gotOwnAction
    @api.on "action", @gotAction
    @api.connect()

  # Public: Api got a connection from server
  gotConnection: () =>
    console.log "Got connection"
    @api.sendHandshake(@name)

  # Public: Skyport logic server sent an error message
  gotError: (errorObject) =>
    console.log "Server sent error"
    console.log errorObject

  # Public: Api received handshake back from server
  gotHandshake: () =>
    console.log "Got handshake from server"

  # Public: Aapi received gamestate with turn number 0
  gotGameStart: (serverstate) =>
    console.log "Got gamestart, send loadout"
    @api.sendLoadout "laser", "mortar"
    console.log "Send loadout"

  # Public: Api received game state of turn > 0
  gotGameState: (gamestate) =>
    console.log "Got gamestate"

  # Public: Api received action message about our own action
  gotOwnAction: (type, actionDetails) ->
    console.log "Got own action"

  # Public: Api received action message about other AI's action
  gotAction: (type, actionDetails, aiName) ->
    console.log "Got AI action"


console.log "Welcome to Simple Walker AI"

if process.argv.length isnt 3
  console.log "Usage: node skyportai.js name_of_the_bot"
  process.exit()

myname = process.argv[2]

ai = new SimpleAI myname