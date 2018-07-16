require 'minitest_helper'

module Sevak
  describe Consumer do

    before do
      Sevak.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
      end
    end

    let(:master_consumer) { Consumer.new }

    it 'respond to start_master_worker method' do
      assert master_consumer.respond_to?(:start_master_worker)
    end

  end
end