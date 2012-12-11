class DevChannel::Connection
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  def initialize(socket)
    info "Streaming DevChannel updates to client #{socket}"
    @socket = socket
    subscribe('file_change', :notify_file_change)
  end

  def notify_file_change(topic, path, relative_path)
    source = DevChannel::SourceFile.new(path)
    instrument :FileChange
    info relative_path
    @socket <<(
      JSON.dump(
        protocol: "loadScript", 
        args: [
          relative_path,
          source.process
        ]
      )
    )
  rescue Reel::SocketError
    info "AssetChangeServer client disconnected"
    terminate
  ensure
    end_instrument :FileChange
  end

  def instrument(id)
    @active ||= {}
    @active[id] = Time.new
  end

  def end_instrument(id)
    started_at = @active.delete(id)
    total = ((Time.new - started_at) * 1000.0).to_s
    info "[#{id}] #{total}ms"
  end
end