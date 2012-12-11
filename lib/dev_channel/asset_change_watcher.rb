class DevChannel::AssetChangeWatcher
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  def initialize(assetfile, assetdir, target)
    @project = Rake::Pipeline::Project.new(assetfile)
    @sources = Set.new

    @assetfile, @assetdir, @target = assetfile, assetdir, target
  end

  def listen
    @project.pipelines.map(&:inputs).each do |map|
      next unless map.keys.grep(Regexp.new(@target)).any?
      @sources.add File.join(
        @assetdir,
        map.keys.first.gsub("./", '')
      )
    end

    info "[AssetChangeServer] #{@sources.inspect}"
    info "@assetdir #{@assetdir}"
    @sources.each do |source|  
      source = File.expand_path(source) 
      info "Listening to #{source}" 
      listener = Listen.to(source).change do |modified, added, removed|
        modified.each &method(:changed)
      end
      listener.start(false)
    end    
  end

  def changed(path)
    relative_path =  Pathname.new(path).relative_path_from(Pathname.new(File.expand_path(@assetdir))).to_s
    relative_path.gsub!(Regexp.new(".*#{@target}/"), '')
    relative_path.gsub!(/\.\.\//, '')
    relative_path.gsub!(/\.[\w]+$/, '')
    info "[Changed: #{relative_path}]"
    publish 'file_change', path, relative_path
  end
end
