module Sevak
  module Core
    def connection
      return @conn if @conn

      @conn ||= Bunny.new(
        host: config.host,
        port: config.port,
        username: config.user,
        password: config.password)

      @conn.start
      @conn
    end

    def log(data)
        @logger ||= ::Sevak.get_logger
        @logger.info(data.inspect)
    end

    def config
      ::Sevak.config
    end
  end
end