Pod::Spec.new do |s|
  s.name = 'Fueled-JSONParsing'
  s.version = '0.2.2'
  s.summary = 'JSON Parsing.'
  s.homepage = 'https://github.com/Vadim-Yelagin/JSONParsing'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = 'Vadim Yelagin'
  s.ios.deployment_target = '8.0'
  s.source = { :git => 'https://github.com/Vadim-Yelagin/JSONParsing.git', :tag => s.version }
  s.source_files = 'JSONParsing/*.swift'
end