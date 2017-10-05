require 'minitest_helper'

module Sevak

  describe Consumer do

    before do
      Sevak.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
      end
    end

    let(:consumer) { Consumer.new }

    it 'respond to start/run interface methods method' do
      assert consumer.respond_to?(:start)
      assert consumer.respond_to?(:run)
    end

    it 'has a default queue' do
      assert_equal consumer.queue_name, 'sevak.default'
    end

    it 'creates connection' do
      assert consumer.connection
    end

    it 'creates a channel' do
      assert consumer.channel
    end

    it 'creates a queue' do
      assert consumer.queue
    end

    it 'loads configuration' do
      assert_equal consumer.config.class, Sevak::Config
    end

    it 'reads the message from the queue' do
      # consumer.stubs(:send_sms).returns(nil)
      consumer.stubs(:wait_for_threads).returns(nil)

      msg = { msisdn: '+919895821948', message: 'This is a test message' }

      while(consumer.queue.message_count > 0) do
        consumer.queue.pop
      end

      100.times do
        consumer.queue.publish(msg.to_json)
      end

      # wait for all the messages to reach the queue
      sleep 1
      assert_equal consumer.queue.message_count, 100
      consumer.start
      sleep 1
      assert_equal consumer.queue.message_count, 0
    end

    it 'reads the sent messagr from the queue' do
      while(consumer.queue.message_count > 0) do
        consumer.queue.pop
      end

      Publisher.publish('timestamp', { time: Time.now.to_i } )

    end
  end
end