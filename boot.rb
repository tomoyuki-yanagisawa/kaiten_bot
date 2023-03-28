require 'bundler'

Bundler.require

require 'active_support/all'

Time.zone = 'Tokyo'

Dir[File.join(__dir__, 'lib', '**', '*.rb')].each do |file|
  require file
end
