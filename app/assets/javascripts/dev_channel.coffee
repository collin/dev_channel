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

  loadScript: (path, source) ->
    console.log "loadScript", path, source.length
    minispade.modules[path] = source
    $?(document).trigger new $.Event("devchannel:script", path: path, source: source)

  loadStyle: (path) ->
    stylesheets = $('[rel="stylesheet"]')
    for stylesheet in stylesheets
      @reloadStyle(stylesheet)

  reloadStyle: (stylesheet) ->
    clone = $(stylesheet).clone()
    href = $(stylesheet).attr("href").replace(/\?.*/, '')
    $(clone).attr("href", "#{href}?#{Math.random()}")
    $(stylesheet).before(clone)
    clone.on "load", -> 
      stylesheet.remove()
    