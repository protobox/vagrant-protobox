module VagrantPlugins
  module Protobox
    module Action
      class SwitchConfig
        def initialize(app, env)
          @app = app
        end

        def call(env)
          system_dir = Protobox.system_dir(env[:root_path])
          config_name = env[:config_name]
          config_dir = system_dir.join("config")
          config_local_path = File.join("data", "config", config_name + ".yml")

          # Create protobox dir if it doesn't exist
          if !File.directory?(system_dir)
            Dir.mkdir(system_dir)
          end

          # Write the config file
          File.open(config_dir, 'w') do |file|
            file.write(config_local_path)
          end

          env[:ui].info(I18n.t("vagrant_protobox.actions.switch_config.switched",
                               :name => config_name))

          @app.call(env)
        end
      end
    end
  end
end
