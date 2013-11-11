net = require "net"

class Connection

  constructor: (@host, @port, @api) ->
    @data = ""

  # Public: Establish connection to skyport logic java server
  connect: () ->
    @data = ""
    @sock = net.createConnection @port, @host
    @sock.on 'connect', () =>
      @api.dispatchTable['connection']()
    @sock.on 'data', (data) =>
      @processData data

  sendPacket: (object) ->
    @sock.write JSON.stringify(object) + "\n"

  # Public: Process packet
  processPacket: (object) ->
    @api.processPacket object

  # Private: Add data to instance's data variable and attempt to read
  processData: (data) =>
    @data += data
    @tryToReadLine()

  # Private: Attempt to read line from data (text)
  tryToReadLine: () ->
    if @data.indexOf '\n' isnt -1
      linebuffer = @data.split '\n'
      @data = linebuffer.pop()
      for line in linebuffer
        do (line) =>
          if line isnt ''
            @processLine line

  # Private: Process one line of data and check if it is a json object
  processLine: (line) ->
    try
      object = JSON.parse line
      @processPacket object
    catch e
      console.log e

module.exports = Connection