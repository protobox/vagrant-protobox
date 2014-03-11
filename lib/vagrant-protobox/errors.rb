require "vagrant"

module VagrantPlugins
  module Protobox
    module Errors
      class VagrantError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_protobox.errors")
      end

      class VersionError < VagrantError
        error_key(:version_error)
      end

      class ConfigNotFound < VagrantError
        error_key(:config_not_found)
      end
    end
  end
end