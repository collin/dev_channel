class window.DevChannel
  constructor: (@host, @port, @Socket=WebSocket) ->
    @connect()

  connect: ->    
    @socket = new @Socket("ws://#{@host}:#{@port}/devchannel")
    @socket.onmessage = @onmessage
    @socket.onclose = @onclose
    @socket.onerror = @onclose

  onmessage: ({data}) =>
    data = JSON.parse data
    @trampoline = undefined
    if data.protocol
      @[data.protocol].apply(this, data.args)

  onclose: (event) =>
    @trampoline ||= 1
    if @trampoline
      console.log "Attempting reconnect #{@trampoline}/3"
    @trampoline++
    if @trampoline < 3
      @connect() 
    else
      console.error "Unexpectedly Closed DevChannel", event
      console.info "Reason Unknown"
      console.log "reload page to reconnect"

  loadStylesheet: (path, source) ->
  
  loadScript: (path, source) ->
    console.log "loadScript", path, source.length
    minispade.modules[path] = source
    