require 'singleton'

module Sevak
  class Publisher
    include Core
    include Singleton

    def self.publish(queue_name, message)
      instance.queue(queue_name).publish(message.to_json)
    end

    def self.delayed_publish(queue_name, message, delay = 0)
      instance.publish_exchange(queue_name, message, delay.to_i)
    end

    def channel
      @channel ||= connection.create_channel
    end

    def queue(queue_name)
      channel.queue(queue_name)
    end

    def exchange(queue_name)
      channel.exchange("#{queue_name}_exchange", type: "x-delayed-message", arguments: { "x-delayed-type" => "direct" })
    end

    def publish_exchange(queue_name, message, delay)
      queue(queue_name).bind(exchange(queue_name))
      exchange(queue_name).publish(message.to_json, headers: { "x-delay" => delay })
    end
  end
end
