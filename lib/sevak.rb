require 'bunny'
require 'yaml'
require 'json'
require 'logger'
require 'fileutils'
require 'sevak/version'

module Sevak

  # initialize configuration from the config/*.yml file
  class Config

    # allowed configurations
    CONFIGURATION = %w(
      host
      port
      user
      password
      prefetch_count
      autoscale
      max_process_limit
      min_process_limit).freeze

    def initialize
      @config = {
        'host' => 'localhost',
        'port' => '5672',
        'user' => 'guest',
        'password' => 'guest',
        'prefetch_count' => 10,
        'autoscale' => false,
        'max_process_limit' => 10,
        'min_process_limit' => 1
      }

      load_configuration_from_yml
    end

    def method_missing(name, *args)
      setter = false

      name = name.to_s

      if name =~ /=$/
        name = name.to_s.chop
        setter = true
      end

      super(name, args) unless CONFIGURATION.include?(name)

      if setter
        set(name, args.first)
      else
        get(name)
      end
    end

    def to_h
      @config
    end

    private

    def load_configuration_from_yml
      if File.exists?('config/sevak.yml')
        @config = @config.merge(YAML.load(File.read('config/sevak.yml')))
      end
    end

    def set(key, val)
      @config[key] = val
    end

    def get(key)
      @config[key]
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config) if block_given?
    config
  end

  def self.get_logger
    if !Dir.exist? 'log'
      FileUtils.mkdir('log')
    end

    logfile = if !testing?
                File.open('log/sevak.log', 'a')
              else
                File.open('log/sevak_test.log', 'a')
              end

    # TODO make configurable
    logfile.sync = true
    @logger = Logger.new(logfile, 'weekly')
  end

  def self.testing?
    defined?(SEVAK_ENV) && (SEVAK_ENV == 'test')
  end

  def self.root
    File.expand_path(File.dirname(File.dirname(__FILE__)))
  end

end

require 'sevak/core'
require 'sevak/autoscale'
require 'sevak/consumer'
require 'sevak/publisher'
require 'sevak/railtie' if defined?(Rails)
