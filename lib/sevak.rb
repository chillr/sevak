Bundler.require(:default)

require 'yaml'
require 'json'
require 'logger'
require 'fileutils'
require 'sevak/version'

module Sevak

  # initialize configuration from the config/*.yml file
  class Config

    # allowed configurations
    CONFIGURATION = %w(host port user password prefetch_count)

    def initialize
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

    private

    def load_configuration_from_yml
      @config = YAML.load(File.read('config/default.yml'))
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

  def self.establish_connection
    return @conn if @conn

    @conn ||= Bunny.new(
      host: config.host,
      port: config.port,
      username: config.user,
      password: config.password)

    @conn.start
    @conn
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

  def self.log(data)
    @logger ||= get_logger
    @logger.info(data.inspect)
  end

  def self.testing?
    defined?(SEVAK_ENV) && (SEVAK_ENV == 'test')
  end

  def self.root
    File.expand_path(File.dirname(File.dirname(__FILE__)))
  end

end

require 'sevak/core'
require 'sevak/consumer'
require 'sevak/publisher'
