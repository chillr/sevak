require 'minitest_helper'

module Sevak

  describe Publisher do
    before do
      Sevak.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
      end
    end

    it 'should have a publish method' do
      assert_equal true, Publisher.respond_to?(:publish)
    end

    it 'should publish message to the queue specified' do
      Publisher.publish('sms', { msisdn: '+919894321290', message: 'Testing the message publish' })
    end
  end
end