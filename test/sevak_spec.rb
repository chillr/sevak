require 'minitest_helper'

describe Sevak do

  it 'is has a verison set' do
    refute_nil ::Sevak::VERSION
  end

  describe Sevak::Config do

    it 'returns the configuration object on initialize' do
      assert_equal Sevak.configure.class, Sevak::Config
    end

    it 'loads the default configuration' do
      assert_equal Sevak.config.host, 'localhost'
    end

    it 'allow to add custom configuration' do
      assert_equal Sevak.config.port, '5672'

      Sevak.configure do |f|
        f.port = '1234'
      end

      assert_equal Sevak.config.port, '1234'
    end

    it 'raise error for unsupported configuration' do
      assert_raises do
        Sevak.configure do |f|
          f.test_port = '1235'
        end
      end
    end
  end

  describe '.establish_connection' do
    before do
      Sevak.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
      end
    end

    it 'establish_connection to a rabbitmq server' do
      assert Sevak.establish_connection
    end
  end

  describe '.log' do
    before do
      Sevak.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
      end
    end

    it 'logs to the standard output' do
      assert Sevak.log('This message will be available in log/sevak_test.log')
    end
  end

  describe '.get_logger' do
    before do
      Sevak.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
      end
    end

    it 'logs to the standard output' do
      assert_equal Sevak.get_logger.class, Logger
    end
  end

  describe '.testing?' do
    it 'return true if running in test mode' do
      assert Sevak.testing?
    end
  end

  describe '.root' do
    it 'returns the root directory' do
      assert_equal Sevak.root, Dir.getwd
    end
  end
end
