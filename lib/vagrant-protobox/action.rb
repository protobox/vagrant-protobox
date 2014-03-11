require 'vagrant/action/builder'

module VagrantPlugins
  module Protobox
    module Action

      def self.action_install
        Vagrant::Action::Builder.new.tap do |b|
          b.use Install
        end
      end

      def self.action_switch
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigExistsCheck
          b.use SwitchConfig
        end
      end

      # The autoload farm
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :Install, action_root.join("install")
      autoload :ConfigExistsCheck, action_root.join("config_exists_check")
      autoload :SwitchConfig, action_root.join("switch_config")
    end
  end
end