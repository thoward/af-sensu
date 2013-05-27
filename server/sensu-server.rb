#!/usr/bin/env ruby
require 'bundler/setup'
Bundler.require

# shim services
if ENV['VCAP_SERVICES']
  require 'json'
  $vcap_services ||= JSON.parse(ENV['VCAP_SERVICES'])

  #redis
  redis_service_name = $vcap_services.keys.find { |svc| svc =~ /redis/i }
  redis_service = $vcap_services[redis_service_name].first
  $redis_config = {
    :host => redis_service['credentials']['host'],
    :port => redis_service['credentials']['port'],
    :password => redis_service['credentials']['password']
  }

  # rabbit
  rabbit_service_name = $vcap_services.keys.find { |svc| svc =~ /rabbit/i }
  rabbit_service = $vcap_services[rabbit_service_name].first

  $rabbit_url = rabbit_service['credentials']['url']

else
  # redis default
  $redis_config = {
    :host => '127.0.0.1',
    :port => 6379
  }

  # rabbit default
  $rabbit_url = "amqp://localhost"
end

if $redis_config[:password]
  redis_url = "redis://:#{$redis_config[:password]}@#{$redis_config[:host]}:#{$redis_config[:port]}/0"
else
  redis_url = "redis://#{$redis_config[:host]}:#{$redis_config[:port]}/0"
end

ENV['REDIS_URL']=redis_url
ENV['RABBITMQ_URL']=$rabbit_url

require 'sensu/server'

options = {}
options[:config_dir] = "./config"
options[:log_level] = :debug

Sensu::Server.run(options)
