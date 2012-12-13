class DevChannel::Connection
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  def initialize(socket)
    info "Streaming DevChannel updates to client #{socket}"
    @socket = socket
    subscribe('script_change', :notify_script_change)
    subscribe('style_change', :notify_style_change)
  end

  def notify_script_change(topic, path, relative_path)
    source = DevChannel::SourceFile.new(path)
    instrument :ScriptChange
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
    end_instrument :ScriptChange
  end

  def notify_style_change(topic)
    instrument :StyleChange
    @socket <<(
      JSON.dump(
        protocol: "loadStyle"#,
        # args: [relative_path]
      )
    )
  rescue Reel::SocketError
    info "AssetChangeServer client disconnected"
    terminate
  ensure
    end_instrument :StyleChange
  end

  def instrument(id)
    @active ||= {}
    @active[id] = Time.new
  end

  def end_instrument(id)
    begin
      started_at = @active.delete(id)
      total = ((Time.new - started_at) * 1000.0).to_s
      info "[#{id}] #{total}ms"
    rescue #whatever!
    end
  end
end