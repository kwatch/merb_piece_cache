# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{merb_piece_cache}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["makoto kuwata"]
  s.date = %q{2009-10-30}
  s.description = %q{Merb plugin to cache html fragment}
  s.email = %q{kwa.at.kuwata-lab.com}
  s.extra_rdoc_files = ["README", "MIT-LICENSE", "TODO"]
  s.files = ["MIT-LICENSE", "README", "Rakefile", "TODO", "lib/merb_piece_cache", "lib/merb_piece_cache/file_cache_store.rb", "lib/merb_piece_cache/helpers.rb", "lib/merb_piece_cache.rb"]
  s.homepage = %q{http://github.com/kwatch/merb_piece_cache/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb_piece_cache}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Merb plugin to cache html fragment}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<called_from>, [">= 0.1.0"])
    else
      s.add_dependency(%q<called_from>, [">= 0.1.0"])
    end
  else
    s.add_dependency(%q<called_from>, [">= 0.1.0"])
  end
end
