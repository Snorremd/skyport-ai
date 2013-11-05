net = require "net"

class Connection

  constructor: (@host, @port, @api) ->
    @data = ""
    console.log JSON.stringify @api

  # Public: Establish connection to skyport logic java server
  connect: () ->
    @data = ""
    @sock = net.createConnection @port, @host
    @sock.on 'connect', () =>
      @api.dispatchTable['connection']()
    @sock.on 'data', (data) =>
      @processData data

  sendPacket: (object) ->
    console.log "Send object to server"
    @sock.write JSON.stringify(object) + "\n"

  # Public: Process packet
  processPacket: (object) ->
    @api.processPacket object

  # Private: Add data to instance's data variable and attempt to read
  processData: (data) ->
    @data += data
    try
      @tryToReadLine()
    catch e
      @api.error e

  # Private: Attempt to read line from data (text)
  tryToReadLine: () ->
    if @data.indexOf '\n' isnt -1
      console.log @data
      linebuffer = @data.split '\n'
      @data = linebuffer.pop()
      for line in linebuffer
        do (line) ->
          if line isnt ''
            try
              @processLine line
            catch e
              throw e
            

  # Private: Process one line of data and check if it is a json object
  processLine: (line) ->
    try
      object = JSON.parse line
      @processPacket object
    catch e
      throw e

module.exports = Connection