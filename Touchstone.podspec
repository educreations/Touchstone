Pod::Spec.new do |s|
  s.name = 'Touchstone'
  s.version = '0.1'
  s.summary = 'Easy defaults for use in debugging and production.'
  s.homepage = 'https://github.com/educreations/Touchstone'
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE'
  }
  s.author = 'Chris Streeter', 'chris@educreations.com'
  s.source = {
    :git => 'https://github.com/educreations/Touchstone.git',
    :tag => 'v0.1'
  }
  s.platform = :ios, '5.0'
  s.source_files = 'Touchstone/Touchstone.{h,m}'
  s.frameworks = 'Foundation'
end
