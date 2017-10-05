require 'singleton'

module Sevak
  class Publisher
    include Core
    include Singleton

    def self.publish(queue_name, message)
      instance.channel.queue(queue_name).publish(message.to_json)
    end

    def channel
      @channel ||= connection.create_channel
    end
  end
end