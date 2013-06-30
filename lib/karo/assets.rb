require 'karo/config'
require 'thor'

module Karo

	class Assets < Thor

    include Thor::Actions

	  desc "pull", "syncs assets from server shared/system/dragonfly/<environment> directory into local system/dragonfly/development directory"
	  def pull
	    configuration = Config.load_configuration(options)

      path_local  = File.expand_path("public/system/dragonfly/development")
      empty_directory path_local unless File.exists?(path_local)

      path_server = File.join(configuration["path"], "shared/system/dragonfly/#{options[:environment]}")

	    host = "deploy@#{configuration["host"]}"
	    cmd  = "rsync -az --progress #{host}:#{path_server}/ #{path_local}/"

      system "#{cmd}"

      say "Sync complete", :green
	  end

    desc "push", "syncs assets from system/dragonfly/development directory into local server shared/system/dragonfly/<environment> directory"
	  def push
      configuration = Config.load_configuration(options)

      path_local  = File.expand_path("public/system/dragonfly/development")
      unless File.exists?(path_local)
        raise Thor::Error, "Please make sure that this local path exists? '#{path_local}'"
      end

      path_server = File.join(configuration["path"], "shared/system/dragonfly/#{options[:environment]}")

      host = "deploy@#{configuration["host"]}"
      cmd  = "rsync -az --progress #{path_local}/ #{host}:#{path_server}/"

      if yes?("Are you sure?", :yellow)
        system "#{cmd}"
        say "Sync complete", :green
      else
        say "Sync cancelled", :yellow
      end
	  end

	end

end