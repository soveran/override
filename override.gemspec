Gem::Specification.new do |s|
  s.name = 'override'
  s.version = '0.0.10'
  s.summary = %{The as-simple-as-possible-but-not-simpler stubbing library.}
  s.description = "Override is the essence of the stubbing concept: it takes an object, a hash of methods/results, and proceeds to rewrite each method in the object. It can be used as a stubbing strategy in most cases"
  s.author = "Michel Martens"
  s.email = "michel@soveran.com"
  s.homepage = "http://github.com/soveran/override"
  s.files = ["lib/override.rb", "README.markdown", "LICENSE", "Rakefile", "test/all_test.rb"]
  s.rubyforge_project = "override"
end
