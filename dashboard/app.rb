#!/usr/bin/env ruby
require 'bundler/setup'
Bundler.require

# shim services
if ENV['VCAP_SERVICES']
  require 'json'
  appfog = {
    "dashboard" => {
      "host" => ENV["VCAP_APP_HOST"],
      "port" => ENV["VCAP_APP_PORT"].to_i
    }
  }

  File.open("./config/appfog.json", "w") do |f|
    f.write(appfog.to_json)
  end
end

require 'sensu-dashboard/server'

options = {}
options[:config_dir] = "./config"
options[:log_level] = :debug

Sensu::Dashboard::Server.setup(options)

Sensu::Dashboard::Server.run(options)
