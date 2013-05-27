#!/usr/bin/env ruby
require 'bundler/setup'
Bundler.require

# shim services
if ENV['VCAP_SERVICES']
  require 'json'
  $vcap_services ||= JSON.parse(ENV['VCAP_SERVICES'])

  # rabbit
  rabbit_service_name = $vcap_services.keys.find { |svc| svc =~ /rabbit/i }
  rabbit_service = $vcap_services[rabbit_service_name].first

  $rabbit_url = rabbit_service['credentials']['url']

else
  # rabbit default
  $rabbit_url = "amqp://localhost"
end

ENV['RABBITMQ_URL']=$rabbit_url

require 'sensu/client'

options = {}
options[:config_dir] = "./config"
options[:log_level] = :debug

Sensu::Client.run(options)
