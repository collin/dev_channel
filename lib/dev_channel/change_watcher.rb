class DevChannel::ChangeWatcher
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  def listen_to(path) 
    source = File.expand_path(path.to_s) 
    info "[DevChannel] Listening to #{source}" 
    listeners << listener = Listen.to(source).change do |modified, added, removed|
      modified.each &method(:changed)
    end
    listener.start(false)
  end

  def listeners
    @listeners ||= []
  end

  def purge
    listeners.each(&:stop)
    @listeners = []
  end
end