$:.push File.expand_path('../lib', __FILE__)

require 'jrails/version'

Gem::Specification.new do |s|
  s.name = 'jrails'
  s.version = Jrails::VERSION
  s.authors = ["Aaron Eisenberger", "Patrick Hurley"]
  s.date = '2016-12-10'
  s.default_executable = %q{jrails}
  s.description = %q{Using jRails, you can get all of the same default Rails helpers for javascript functionality using the lighter jQuery library.}
  s.email = %q{aaronchi@gmail.com}
  s.executables = ['jrails']
  s.extra_rdoc_files = [
    "CHANGELOG",
     "LICENSE",
     "README.rdoc"
  ]
  s.files       = `git ls-files`.split("\n")
  s.homepage = %q{http://ennerchi.com/projects/jrails}
  s.rdoc_options = ["--charset=UTF-8"]
  s.summary = %q{jRails is a drop-in jQuery replacement for the Rails Prototype/script.aculo.us helpers.}

  s.add_dependency 'rails', '>= 4.0.0'
end

