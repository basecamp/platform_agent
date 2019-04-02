Gem::Specification.new do |s|
  s.name     = 'platform_agent'
  s.version  = '1.0.0'
  s.authors  = 'David Heinemeier Hansson'
  s.email    = 'david@basecamp.com'
  s.summary  = 'Parse user agent to deduce the platform.'
  s.homepage = 'https://github.com/basecamp/platform_agent'
  s.license  = 'MIT'

  s.required_ruby_version = '>= 2.4.0'

  s.add_dependency 'activesupport', '>= 5.2.0'
  s.add_dependency 'useragent', '~> 0.16.3'

  s.add_development_dependency 'activemodel', '>= 5.2.0'
  s.add_development_dependency 'bundler', '~> 1.15'

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
