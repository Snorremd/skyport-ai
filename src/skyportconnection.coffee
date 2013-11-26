net = require "net"

# Define a `Connection` class. It handels connections to the Skyport
# server. More specifically it creates a socket connection to the server
# and reads and sends JSON messages.
class Connection

  # Constructor method for the `Connection` class. It takes a
  # `@host` name as a string, a `@port` as an integer and a
  # reference `@api` to the API instance.
  constructor: (@host, @port, @api) ->
    @data = ""

  # Connect to the Skyport server. Use `net` package to create
  # a socket. Call the `@api` instance's connect method when we
  # receive connection confirmation from the socket. Call this
  # object's processData method under this environment variable.
  connect: () ->
    @data = ""
    @sock = net.createConnection @port, @host
    @sock.on 'connect', () =>
      @api.dispatchTable['connection']()
    @sock.on 'data', (data) =>
      @processData data

  # Send a JSON packet to the server.
  sendPacket: (object) ->
    @sock.write JSON.stringify(object) + "\n"

  # Process a JSON packet received from Skyport server.
  processPacket: (object) ->
    @api.processPacket object

  # We received data from the Skyport server.
  # Add data to this instance's `@data` property and
  # attempt to read as line of data.
  processData: (data) =>
    @data += data
    @tryToReadLine()

  # Attempt to read line from `@data`. If it is a non-empty
  # value process it.
  tryToReadLine: () ->
    if @data.indexOf '\n' isnt -1
      linebuffer = @data.split '\n'
      @data = linebuffer.pop()
      for line in linebuffer
        do (line) =>
          if line isnt ''
            @processLine line

  # Process one line of data and check if it is a json object
  # If it is a json packet, process the JSON packet.
  # TODO: Check which kind of errors to catch
  processLine: (line) ->
    #try
    object = JSON.parse line
    @processPacket object
    #catch e
    #console.log e

# Export `Connection` class.
module.exports = Connection