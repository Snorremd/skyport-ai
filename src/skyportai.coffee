SkyportAPI = require("./skyportapi")

class SimpleAI

  constructor: (@name) ->
    @api = new SkyportAPI @name
    @api.on "connection", @gotConnection
    @api.on "error", @gotError
    @api.on "handshake", @gotHandshake
    @api.on "gamestart", @gotGameStart
    @api.on "gamestate", @gotGameState
    @api.connect()

  # Public: Called when the api gets a connection from server
  gotConnection: () =>
    console.log "Got connection"
    @api.sendHandshake(@name)

  # Public: Called when skyport logic server sends an error message
  gotError: (errorObject) =>
    console.log "Server sent error"
    console.log errorObject

  # Public: Called when api receives handshake back from server
  gotHandshake: () =>
    console.log "Got handshake from server"

  gotGameStart: (map, players) =>
    console.log "Got gamestart, send loadout"
    @api.sendLoadout "laser", "mortar"

  gotGameState: (turn, map, players) =>
    console.log "Got gamestate"

console.log "Welcome to Simple Walker AI"

if process.argv.length isnt 3
  console.log "Usage: node skyportai.js name_of_the_bot"
  process.exit()

myname = process.argv[2]

ai = new SimpleAI myname