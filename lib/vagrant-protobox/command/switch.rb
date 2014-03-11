require 'optparse'

module VagrantPlugins
  module Protobox
    module Command
      class Switch < Vagrant.plugin("2", :command)
        def execute
          options = { verbose: false }

          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant protobox switch <config>"
            #o.separator ""
            #o.separator "Options:"
            #o.separator ""
          end

          # Parse the options
          argv = parse_options(opts)
          return if !argv

          if argv.empty? || argv.length > 1
            raise Vagrant::Errors::CLIInvalidUsage,
              help: opts.help.chomp
          end

          config = argv[0]

          @env.action_runner.run(Protobox::Action.action_switch, {
            config_name: config,
            ui: Vagrant::UI::Prefixed.new(@env.ui, "protobox"),
          })

          # Success, exit status 0
          0
        end
      end
    end
  end
end