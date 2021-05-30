source 'https://rubygems.org'

gemspec

if RUBY_VERSION == "2.0.0"
  gem "json", "2.4.1"
  gem "rake", "12.3.3"
end
group :test do
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.5.0")
    gem "coveralls_reborn", "~> 0.21.0"
    gem "simplecov", "~> 0.21.0"
  end
  gem "yardstick", "~> 0.9.9"
end
