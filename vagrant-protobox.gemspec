# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "vagrant-protobox/version"

Gem::Specification.new do |s|
  s.name        = "vagrant-protobox"
  s.version     = VagrantPlugins::Protobox::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Patrick Heeney']
  s.email       = ["patrickheeney@gmail.com"]
  s.homepage    = "http://getprotobox.com"
  s.license     = "MIT"
  s.summary     = "The official getprotobox.com command line helper."
  s.description = "The official getprotobox.com command line helper."

  s.rubyforge_project = s.name
  s.post_install_message =<<eos
********************************************************************************

  Web GUI: http://getprotobox.com/

  Follow @getprotobox on Twitter for announcements, updates, and news.
  https://twitter.com/getprotobox

********************************************************************************
eos

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.require_paths = ["lib"]

  root_path   = File.dirname(__FILE__)
  all_files   = Dir.chdir(root_path) { Dir.glob("**/{*,.*}") }
  all_files.reject! { |file| [".", ".."].include?(File.basename(file)) }

  gitignore_path = File.join(root_path, ".gitignore")
  gitignore      = File.readlines(gitignore_path)
  gitignore.map! { |line| line.chomp.strip }
  gitignore.reject! { |line| line.empty? || line =~ /^(#|!)/ }

  unignored_files = all_files.reject do |file|
    # Ignore any directories, the gemspec only cares about files
    next true if File.directory?(file)

    # Ignore any paths that match anything in the gitignore. We do
    # two tests here:
    #
    #   - First, test to see if the entire path matches the gitignore.
    #   - Second, match if the basename does, this makes it so that things
    #     like '.DS_Store' will match sub-directories too (same behavior
    #     as git).
    #
    gitignore.any? do |ignore|
      File.fnmatch(ignore, file, File::FNM_PATHNAME) ||
        File.fnmatch(ignore, File.basename(file), File::FNM_PATHNAME)
    end
  end

  s.files         = unignored_files
  s.executables   = unignored_files.map { |f| f[/^bin\/(.*)/, 1] }.compact
  s.require_path  = 'lib'


  #s.add_development_dependency "bundler", "~> 1.3"
  #s.add_development_dependency "rake"
  #s.add_development_dependency "rspec"
end