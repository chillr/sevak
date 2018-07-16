require 'minitest_helper'

module Sevak

  describe Publisher do
    before do
      Sevak.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
      end
      @pub = Publisher.send(:new)
      @queue_name = 'sms'
    end

    it 'should have a publish method' do
      assert Publisher.respond_to?(:publish)
    end

    it 'should have a delayed_publish method' do
      assert Publisher.respond_to?(:delayed_publish)
    end

    describe '#channel' do
      it 'should create a channel' do
        @pub.channel
        refute_nil @pub.instance_variable_get(:@channel)
      end
    end

    describe '#queue' do
      before do
        @pub.queue(@queue_name)
      end

      it 'should create a queue with the given name' do
        assert_equal @pub.instance_variable_get(:@channel).queues.count, 1
        assert_includes @pub.instance_variable_get(:@channel).queues.keys, @queue_name
      end

      it 'should create a durable queue' do
        assert @pub.instance_variable_get(:@channel).queues[@queue_name].durable?
      end
    end

    describe '#publish' do
      it 'should publish message to the queue specified' do
        Publisher.publish(@queue_name, { msisdn: '+919894321290', message: 'Testing the message publish' })
      end
    end

    describe '#exchange' do
      before do
        @pub.exchange('sms')
        @exchange_name = "#{@queue_name}_exchange"
      end

      it 'should create an exchange with name #{@queue_name}_exchange specified' do
        assert_equal @pub.instance_variable_get(:@channel).exchanges.count, 1
        assert_includes @pub.instance_variable_get(:@channel).exchanges.keys, @exchange_name
      end

      it 'should create an exchange with type x-delayed-message' do
        assert_equal @pub.instance_variable_get(:@channel).exchanges[@exchange_name].type, "x-delayed-message"
      end

      it 'should create a durable exchange' do
        assert @pub.instance_variable_get(:@channel).exchanges[@exchange_name].durable?
      end
    end

    describe '#delayed_publish' do
      before do
        @pub.queue(@queue_name).purge
        Publisher.delayed_publish(@queue_name, { msisdn: '+919894321290', message: 'Testing the delayed message publish' }, 5000)
      end

      it 'should route messages from the exchange to the queue' do
        assert_equal 0, @pub.queue(@queue_name).message_count
        sleep 10
        assert_equal 1, @pub.queue(@queue_name).message_count
      end
    end

  end
end
