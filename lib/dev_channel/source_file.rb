class DevChannel::MinispadeFilter < Rake::Pipeline::Filter
  REQUIRE_FILTER = /^require[ ]?/
  def generate_output(inputs, output)
    inputs.each do |input|
      result = File.read(input.fullpath)
      result.gsub!(REQUIRE_FILTER) do |match|
        "minispade.require "
      end
      output.write result
    end
  end
end

class DevChannel::SourceFile < Pathname
  include Celluloid
  include Celluloid::Logger


  def process
    new_path = "outfile.js"
    path = self
    info "[Process] #{path.dirname} #{path.basename}"
    project = Rake::Pipeline::Project.build do
      tmpdir "tmp"
      output "tmp"  

      input path.dirname.to_s do
        match path.basename.to_s do
          filter PathologyConstantFilter
          filter DevChannel::MinispadeFilter
          coffee_script
          concat new_path
        end
      end
    end

    out_path = "tmp/#{new_path}"
    project.invoke
    File.read(out_path)
  rescue Exception => error
    error error
  end

  def client_path
    client_path = to_s
    client_path.gsub! /.coffee/, ''
    client_path.gsub! path.dirname.to_s, ''
    client_path.gsub! /^\//, ''
  end
end