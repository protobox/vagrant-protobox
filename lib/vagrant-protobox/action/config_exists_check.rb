require "vagrant/plugin/manager"

module VagrantPlugins
  module Protobox
    module Action
      class ConfigExistsCheck
        def initialize(app, env)
          @app = app
        end

        def call(env)
          system_dir = Protobox.system_dir(env[:root_path])
          config_name = env[:config_name]
          config_dir = system_dir.join("config")
          data_dir = env[:root_path].join("data", "config")
          config_path = data_dir.join(config_name + ".yml")

          if !File.exist?(config_path)
            raise Protobox::Errors::ConfigNotFound,
              name: config_name,
              path: config_path
          end

          @app.call(env)
        end
      end
    end
  end
end
