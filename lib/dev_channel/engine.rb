module DevChannel
  require "dev_channel/connection"
  require "dev_channel/change_watcher"
  require "dev_channel/stylesheet_change_watcher"
  require "dev_channel/script_change_watcher"
  require "dev_channel/asset_change_server"
  require "dev_channel/source_file"


  class Engine < ::Rails::Engine
    isolate_namespace DevChannel
  
    config.to_prepare do #{}"dev_channel stylesheet watcher" do
      Celluloid::Actor[:asset_change_server].async.listen_to_stylesheets
    end
  end


  def self.add_projects(*asset_files)
    asset_files.each do |(file, target)|
      Celluloid::Actor[:asset_change_server].async.add_project(file, target)
    end
  end
end
