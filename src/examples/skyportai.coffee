# RandomAI
# --------
# This module implements a random walker ai.
# The bot moves randomly and shoots the laser
# and mortars in random directions.
# The module use the SkyportAPI class to enable easy
# communication with the Skyport Logic Server.
SkyportAPI = require "../skyportapi"

# Define a new RandomAI class
class RandomAI

  # Constructor function for the RandomAI class.
  # It takes a string name as parameter, and creates
  # a new api object. It registers a set of instance
  # methods in the API's dispatch table. These methods
  # are called whenever the API receives messages from
  # the Skyport Logic server. All dispatch table methods
  # are run in a closure encasing the methods in the instance's
  # variable environment.
  constructor: (@name) ->
    @api = new SkyportAPI @name
    @api.on "connection", @gotConnection
    @api.on "error", @gotError
    @api.on "handshake", @gotHandshake
    @api.on "gamestart", @gotGameStart
    @api.on "gamestate", @gotGameState
    @api.on "myturn", @gotMyTurn
    @api.on "own_action", @gotOwnAction
    @api.on "action", @gotAction
    @api.connect()

    @myActions = ["move", "laser"]

  # Api got a physical connection to server.
  # Send handshake to server.
  gotConnection: () =>
    console.log "Got connection"
    @api.sendHandshake(@name)

  # Skyport logic server sent an error message.
  # Example: `{"error":"You need to send a handshake first"}`.
  # Print the error message object to console.
  gotError: (errorObject) =>
    console.log "Server sent error"
    console.log errorObject

  # Api received handshake back from server.
  # Server sent: `{"message":"connect", "status":true}`.
  # Log handshake confirmation to console.
  gotHandshake: () =>
    console.log "Got handshake from server"

  # Api received gamestate with turn number 0 and processed it.
  # The gamestate parameter is an instance of `GameState` and
  # has the following structure:
  # ```
  # {myName:"bobthorn",
  #  map:{
  #     jLength:15, kLength:15,
  #     mapData:[
  #       [{j:0,k:0,value:"V"},{j:0,k:1,value:"V"}, ...,],
  #       [..., {j:14,k:13,value:"V"},{j:14,k:14,value:"V"}]]
  #   },
  #   turn:0,
  #   players:[{name:"frankdudd"},{name:"bobthorn"}]
  # }```
  gotGameStart: (gamestate) =>
    console.log JSON.stringify gamestate
    console.log "Got gamestart, send loadout"
    @api.sendLoadout "laser", "mortar"

  # Api received game state of turn > 0 for enemy players turn and
  # updated the `GameState` instance with player info:
  # ```
  # "players":[
  #   {name:"playerA",
  #    "primary-weapon": {name:"laser", level:1},
  #    "secondary-weapon": {name:"laser", level:1},
  #    health:100,
  #    score:0,
  #    position":"4,0"},
  #    {"name":"you", ...,}```
  gotGameState: (gamestate) =>
    console.log "Got game state for enemy turn"

  # Api received game state for our turn and updated
  # the `GameState` instance with player info.
  gotMyTurn: (gamestate) =>
    choice =  @myActions[Math.floor Math.random() * @myActions.length]
    switch choice
      when "move" then @randomMove gamestate
      when "laser" then @randomLaser gamestate
      else console.log "Nothing"

  # Api received action message about our own action.
  # The `type` parameter specifies the type of action taken:
  # `move, mine, upgrade, laser, droid`.
  # The `actionDetails` parameter gives extra details about
  # the action taken.
  gotOwnAction: (type, actionDetails) ->
    console.log "Got own action"

  # Api received action message about other AI's action.
  # The `type` parameter specifies the type of action taken:
  # `move, mine, upgrade, laser, droid`.
  # The `actionDetails` parameter gives extra details about
  # the action taken.
  # An additional parameter `aiName` specifies which AI took the action.
  gotAction: (type, actionDetails, aiName) ->
    console.log "Got AI action"

  # Perform a random move. The method parameter gamestate, an instance of
  # `GameState` provides info about the players position. Legal hexagons are
  # calculated from the `Map` instance. Send a move message to the server via
  # the api object.
  randomMove: (gamestate) ->
    myPos = gamestate.players[0].position
    myHex = gamestate.map.mapData[myPos.j][myPos.k]
    neighbours = gamestate.map.neighbours myHex
    neighbours = neighbours.filter (hexagon) =>
      gamestate.map.walkable hexagon.j, hexagon.k
    randNeighbour = neighbours[Math.floor Math.random() * neighbours.length]
    direction = myHex.direction randNeighbour

    console.log "My position is " + JSON.stringify myHex
    console.log "My neighbours are " + JSON.stringify neighbours
    console.log "Move #{direction}"

    @api.move direction

  # Perform a random laser attack.
  randomLaser: (gamestate) ->
    console.log JSON.stringify gamestate.map.DIRECTIONS
    directions = gamestate.map.constructor.DIRECTIONS
    randDirection = directions[Math.floor Math.random() *
                                   directions.length]

    console.log "I'm going to shoot #{randDirection}"
    @api.laser randDirection


# Print a welcome message
console.log "Welcome to Random Walker AI"

# Check that the user runs script with the correct number of args.
if process.argv.length isnt 3
  console.log "Usage: node skyportai.js name_of_the_bot"
  process.exit()

myname = process.argv[2]

# Instantiate new AI object
ai = new RandomAI myname
