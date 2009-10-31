require 'rubygems'
require 'rake/gempackagetask'

require 'merb-core'
require 'merb-core/tasks/merb'

GEM_NAME = "merb_piece_cache"
GEM_VERSION = "0.1.0"
AUTHOR = "makoto kuwata"
EMAIL = "kwa.at.kuwata-lab.com"
HOMEPAGE = "http://github.com/kwatch/merb_piece_cache/"
SUMMARY = "Merb plugin to cache html fragment"

@copyright = 'copyright(c) 2009 kuwata-lab.com all rights reserved.'
@license = 'MIT License'

spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'merb_piece_cache'
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = false
  s.extra_rdoc_files = ["README", "MIT-LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  #s.add_dependency('merb', '>= 1.0.12')
  s.add_dependency('called_from', ['>= 0.1.0'])
  s.require_path = 'lib'
  #s.files = %w(MIT-LICENSE README Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
  s.files = %w(MIT-LICENSE README Rakefile TODO) + Dir.glob("{lib}/**/*")
end

#Rake::GemPackageTask.new(spec) do |pkg|
#  pkg.gem_spec = spec
#end

desc "install the plugin as a gem"
task :install do
  Merb::RakeHelper.install(GEM_NAME, :version => GEM_VERSION)
end

desc "Uninstall the gem"
task :uninstall do
  Merb::RakeHelper.uninstall(GEM_NAME, :version => GEM_VERSION)
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "create gem package"
task :package => [:gemspec] do
  dir = "build"
  rm_rf dir
  mkdir dir
  #cp_r spec.files, dir
  sh "tar cf - #{spec.files.join(' ')} | (cd #{dir}; tar xf -)"
  Dir.glob("#{dir}/**/*").each do |fpath|
    next unless File.file?(fpath)
    next if File.basename(fpath) == 'Rakefile'
    s = File.open(fpath, 'rb') {|f| f.read }
    s.gsub! /\$Release\$/,     GEM_VERSION
    s.gsub! /\$Release:.*?\$/, "$Release: #{GEM_VERSION} $"
    s.gsub! /\$Copyright\$/,   @copyright
    s.gsub! /\$License\$/,     @license
    File.open(fpath, 'wb') {|f| f.write s }
  end
  cp "#{GEM_NAME}.gemspec", dir
  chdir dir do
    sh "gem build #{GEM_NAME}.gemspec"
    mv "#{GEM_NAME}-#{GEM_VERSION}.gem", ".."
  end
end

desc "install gem package"
task :inst => [:package] do
  sh "gem install #{GEM_NAME}-#{GEM_VERSION}.gem"
end


spec
