require "bundler"

Bundler.require

require "active_support/all"
require "bigdecimal/util"

Dotenv.load

$config = YAML.load(ERB.new(File.read("./config.yml")).result)
$logger = Logger.new($stdout)

Time.zone = "Tokyo"

Dir[File.join(__dir__, "apis", "**", "*.rb")].each do |file|
  require file
end

Dir[File.join(__dir__, "lib", "**", "*.rb")].each do |file|
  require file
end

Dir[File.join(__dir__, "store", "**", "*.rb")].each do |file|
  require file
end
