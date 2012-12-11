require 'set'
class DevChannel::AssetChangeServer
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  attr_reader :watchers

  def initialize
    @watchers = []
    super
  end

  def add_project(assetfile, target)
    assetdir = Pathname.new(assetfile).dirname.to_s
    target = target
    watcher = DevChannel::AssetChangeWatcher.new(assetfile, assetdir, target)
    @watchers << watcher
    watcher.listen
  end
end

DevChannel::AssetChangeServer.supervise_as :asset_change_server
