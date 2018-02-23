# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'remotedatacli'
  s.version     = '0.0.0'
  s.date        = '2018-02-23'
  s.summary     = "RemoteDataCli"
  s.description = "RemoteDataCli help a restful service communication."
  s.authors     = ["Albert Yangchuanosaurus Zhao"]
  s.email       = '355592261@qq.com'
  #s.files       = Dir['lib/   *.rb'] + Dir['bin/*'] + Dir['templates/*']
  s.files       = `git ls-files`.split("\n")

  s.executables << 'remotedatacli'
  s.homepage    =
    'http://rubygems.org/gems/remotedatacli'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.0.0'
end