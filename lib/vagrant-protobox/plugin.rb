begin
  require 'vagrant'
rescue LoadError
  raise 'The protobox plugin must be run within Vagrant.'
end

# sanity check 
if Vagrant::VERSION < "1.5.0"
  raise 'The protobox plugin is only compatible with Vagrant 1.5+'
end

# Add our custom translations to the load path
I18n.load_path << File.expand_path("../../../locales/en.yml", __FILE__)

module VagrantPlugins
  module Protobox

    def initialize
      puts "here"
      exit
    end
    
    class Plugin < Vagrant.plugin("2")
      name "vagrant-protobox"
      description <<-DESC
      The `protobox` plugin allows you to interact with your getprotobox.com install.
      DESC

      command("protobox") do
        require_relative 'command/root'
        Command::Root
      end



      # This initializes the internationalization strings.
      #def self.setup_i18n
      #  I18n.load_path << File.expand_path("locales/en.yml", Protobox.source_root)
      #  I18n.reload!
      #end

    end
  end
end