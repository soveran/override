Gem::Specification.new do |s|
  s.name = 'override'
  s.version = '0.0.7'
  s.summary = %{The as-simple-as-possible-but-not-simpler stubbing library.}
  s.date = %q{2009-03-13}
  s.author = "Michel Martens"
  s.email = "michel@soveran.com"
  s.homepage = "http://github.com/soveran/override"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.files = ["lib/override.rb", "README.markdown", "LICENSE", "Rakefile", "test/all_test.rb"]

  s.require_paths = ['lib']

  s.add_dependency("metaid", ">= 1.0")

  s.has_rdoc = false
end

