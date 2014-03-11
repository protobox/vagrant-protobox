require "digest/sha1"
require "log4r"
require "pathname"
require "uri"

require 'net/http'
require 'yaml'

#
# TODO:
# - switch downloading to vagrant util
# - move yaml to a protobox/util folder
# - add meta verification
#

#require "vagrant/box_metadata"
#require "vagrant/util/downloader"
#require "vagrant/util/file_checksum"
#require "vagrant/util/platform"

module VagrantPlugins
  module Protobox
    module Action
      class Install
        # This is the size in bytes that if a file exceeds, is considered
        # to NOT be metadata.
        METADATA_SIZE_LIMIT = 20971520

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("protobox::action::install")
        end

        def call(env)

          url_name = env[:install_url]

          @logger.info("Downloading config: #{url_name} => config/name")

          env[:ui].info("Downloading config: #{url_name} => config/name")

          # Build http
          uri = URI.parse(url_name.to_s)
          http = Net::HTTP.new(uri.host, uri.port)

          # Build request
          request = Net::HTTP::Get.new(uri.request_uri)
          request["User-Agent"] = "Protobox"

          # Get response
          response = http.request(request)

          # Check for invalid resonse code
          if response.code != "200"
            puts "Could not fetch url: #{url_name}"
            exit(-1)
          end

          # Store response
          body = response.body.to_s

          # Convert tabs to spaces
          body = body.gsub!(/(?:^ {2})|\G {2}/m, "  ")

          # Check for yaml document starter
          #if !!yaml[/^---/m]
          #  body = "---\n" + body
          #end

          # Validate response
          begin
            yaml_data = YAML.load(body)
          rescue Exception
            puts "Failed parse yaml for #{url_name}: #{$!}"
            #puts "Failed parse yaml for #{url_name}"
            exit(-1)
          end
          
          # Validate yaml
          if !yaml_data.instance_of?(Hash)
            puts "Invalid yaml for #{url_name}"
          end

          # Check for protobox data
          if yaml_data['protobox'].nil? or yaml_data['protobox']['version'].nil? or yaml_data['protobox']['document'].nil?
            puts "Document is missing protobox information"
            exit(-1)
          end

          document = yaml_data['protobox']['document']

          # Check for bad document name
          if document == 'common'
            puts "Invalid protobox document name"
            exit(-1)
          end

          system_dir = Protobox.system_dir(env[:root_path])
          config_dir = system_dir.join("config")
          data_dir = env[:root_path].join("data", "config")
          config_path = data_dir.join(document + ".yml")
          config_local_path = File.join("data", "config", document + ".yml")


          # Save document to file system
          File.open(config_path, 'w') do |file|
            file.write(body)
          end

          # Write the boot file
          File.open(config_dir, 'w') do |file|
            file.write(config_local_path)
          end

          env[:ui].info("You can now 'vagrant up' using the '#{document}' configuration")

          @app.call(env)
        end
      end
    end
  end
end
