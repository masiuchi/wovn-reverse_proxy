# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wovn/reverse_proxy/version'

Gem::Specification.new do |spec|
  spec.name          = 'wovn-reverse_proxy'
  spec.version       = Wovn::ReverseProxy::VERSION
  spec.authors       = ['Masahiro Iuchi']
  spec.email         = ['masahiro.iuchi@gmail.com']

  spec.summary       = 'Translation proxy by wovnrb.'
  spec.description   = 'Translation proxy by wovnrb and WOVN.io.'
  spec.homepage      = 'https://github.com/masiuchi/wovn-reverse_proxy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^test/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'rack', '>= 1.6.4'
  spec.add_dependency 'rack-reverse-proxy', '~> 0.11'
  spec.add_dependency 'wovnrb', '~> 0.2'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'minitest', '~> 5.9'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'rake', '~> 10.0'
end
