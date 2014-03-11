require 'optparse'

module VagrantPlugins
  module Protobox
    module Command
      class Install < Vagrant.plugin("2", :command)
        def execute
          options = { verbose: false }

          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant protobox install [options] <url>"
            o.separator ""
            o.separator "Options:"
            o.separator ""

            o.on("-c", "--clean", "Clean any temporary download files") do |c|
              options[:clean] = c
            end

            o.on("-f", "--force", "Overwrite an existing box if it exists") do |f|
              options[:force] = f
            end

            o.on("--verbose", "Enable verbose output for the installation") do |v|
              options[:verbose] = v
            end

            o.separator ""
          end

          # Parse the options
          argv = parse_options(opts)
          return if !argv

          if argv.empty? || argv.length > 2
            raise Vagrant::Errors::CLIInvalidUsage,
              help: opts.help.chomp
          end

          url = argv[0]
          if argv.length == 2
            options[:name] = argv[0]
            url = argv[1]
          end

          # Install the gem
          #argv.each do |name|
          #  action(Action.action_install, {
          #    :plugin_entry_point => options[:entry_point],
          #    :plugin_version     => options[:plugin_version],
          #    :plugin_sources     => options[:plugin_sources],
          #    :plugin_name        => name,
          #    :plugin_verbose     => options[:verbose]
          #  })
          #end

          @env.action_runner.run(Protobox::Action.action_install, {
            install_url: url,
            install_name: options[:name],
            install_verbose: options[:verbose],
            ui: Vagrant::UI::Prefixed.new(@env.ui, "protobox"),
          })

          # Success, exit status 0
          0
        end
      end
    end
  end
end