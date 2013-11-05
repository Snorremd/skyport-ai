SkyportAPI = require("./skyportapi")

class SimpleAI

  constructor: (@name) ->
    @api = new SkyportAPI @name
    @api.on "connection", @gotConnection
    @api.on "handshake", @gotHandshake
    @api.connect()

  # Public: Called when the api gets a connection from server
  gotConnection: () =>
    console.log "Got connection"
    @api.sendHandshake(@name)

  # Public: Called when api receives handshake back from server
  gotHandshake: () =>
    console.log "Got handshake from server"

  gotGameStart: (map, players) =>
    console.log "Got gamestart, send loadout"
    @api.sendLoadout "laser", "mortar"


console.log "Welcome to Simple Walker AI"

if process.argv.length isnt 3
  console.log "Usage: node skyportai.js name_of_the_bot"
  process.exit()

myname = process.argv[2]

ai = new SimpleAI myname