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
    watcher = DevChannel::ScriptChangeWatcher.new(assetfile, assetdir, target)
    @watchers << watcher
    watcher.async.listen
  end

  def listen_to_stylesheets
    watcher = DevChannel::StylesheetChangeWatcher.new
    @watchers << watcher
    watcher.async.listen
  end
end

DevChannel::AssetChangeServer.supervise_as :asset_change_server
