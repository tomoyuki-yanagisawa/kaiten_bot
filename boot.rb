require 'bundler'

Bundler.require

Dir[File.join(__dir__, 'lib', '**', '*.rb')].each do |file|
  require file
end
