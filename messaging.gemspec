$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "messaging/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "messaging"
  s.version     = Messaging::VERSION
  s.authors     = ["Jeff Dickey", "Frode Fikke"]
  s.email       = ["me@jeffdickey.info", "frodefi@gmail.com"]
  s.homepage    = "http://github.com/frodefi/rails-messaging"
  s.summary     = "Messenging gem for rails app"
  s.description = "Messaging allows you to put have messaigng support in a rails or refinery application."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"
  s.add_dependency "devise"
  s.add_dependency "simple_form"
  s.add_dependency "carrierwave"
  s.add_dependency "sunspot_rails"
  s.add_dependency "jquery-rails"
  s.add_dependency "haml"

  s.add_development_dependency "sqlite3"
end
