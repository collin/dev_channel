class DevChannel::StylesheetChangeWatcher < DevChannel::ChangeWatcher

  def listen
    purge
    stylesheet_paths.each do |path|
      listen_to(path)
    end
  end

  def stylesheet_paths
    Rails.application.assets.paths.grep(/stylesheets/)
  end

  def changed(path)
    # info "StylesheetChangeWatcher #{path}"
    return unless path =~ /s.ss$/
    # relative_path = path
    # relative_path.gsub!(/.+assets|vendor/, '')
    # info "StylesheetChangeWatcher #{path} #{relative_path}"
    # # relative_path =  Pathname.new(path).relative_path_from(Pathname.new(File.expand_path(@assetdir))).to_s
    # # relative_path.gsub!(Regexp.new(".*#{@target}/"), '')
    # # relative_path.gsub!(/\.\.\//, '')
    # # relative_path.gsub!(/\.s.ss+$/, '')
    info "StylesheetChangeWatcher #{path}"
    # info "[Changed: #{relative_path}]"
    publish 'style_change'#, path, relative_path
  end

end