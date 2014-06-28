require "pathname"

require 'vagrant-protobox/version'
require 'vagrant-protobox/plugin'

module VagrantPlugins
  module Protobox
    lib_path = Pathname.new(File.expand_path("../vagrant-protobox", __FILE__))
    autoload :Action, lib_path.join("action")
    autoload :Errors, lib_path.join("errors")

    def self.logo 
      return <<-LOGOBLOCK
                   __         __                
 .-----.----.-----|  |_.-----|  |--.-----.--.--.
 |  _  |   _|  _  |   _|  _  |  _  |  _  |_   _|
 |   __|__| |_____|____|_____|_____|_____|__.__|
 |__|                                           
LOGOBLOCK
    end

    def self.system_dir(path)
      @system_dir ||= Pathname.new(File.expand_path("./.protobox", path))
    end

    # This returns the path to the source of this plugin.
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
