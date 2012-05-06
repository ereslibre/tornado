Gem::Specification.new do |s|
  s.name        = 'tornado'
  s.version     = '0.0.1'
  s.date        = Time.now
  s.summary     = 'Tornado Network library'
  s.description = 'Library for the Tornado P2P Network'
  s.authors     = ['Rafael Fernández López']
  s.email       = 'ereslibre@ereslibre.es'
  s.files       = Dir.glob("{bin,lib,config}/**/*")
  s.homepage    = 'http://www.ereslibre.es/'
  s.executables << 'tornado' << 'tornado_server'
end
