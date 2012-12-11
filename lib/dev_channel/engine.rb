module DevChannel
  require "dev_channel/connection"
  require "dev_channel/asset_change_watcher"
  require "dev_channel/asset_change_server"
  require "dev_channel/source_file"


  class Engine < ::Rails::Engine
    isolate_namespace DevChannel
  
  end


  def self.add_projects(*asset_files)
    asset_files.each do |(file, target)|
      Celluloid::Actor[:asset_change_server].add_project(file, target)
    end
  end
end
