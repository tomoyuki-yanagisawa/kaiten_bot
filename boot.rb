require "bundler"

Bundler.require

require "active_support/all"
require "bigdecimal/util"

Dotenv.load

$config = YAML.load(ERB.new(File.read("./config.yml")).result)
$logger = Logger.new($stdout)

Time.zone = "Tokyo"

Dir[File.join(__dir__, "exchange", "**", "*.rb")].sort_by(&:itself).each do |file|
  require file
end

Dir[File.join(__dir__, "store", "**", "*.rb")].sort_by(&:itself).each do |file|
  require file
end

require "./helper"
