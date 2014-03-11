# -*- mode: ruby -*-
# vi: set ft=ruby :

# Check for protobox plugin
if !Vagrant.has_plugin?('vagrant-protobox')
  puts "Protobox vagrant plugin missing, run the following:"
  puts "bundle"
  puts "bundle exec vagrant up"
  exit
end

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.synced_folder "./", "/vagrant", id: 'vagrant-root', nfs: true
end