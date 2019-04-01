module Sevak
  module Core
    def connection
      begin
        return @conn if @conn
        host = config.host.kind_of?(Array) ? config.host : [config.host]
        @conn ||= Bunny.new(
          hosts: host,
          port: config.port,
          username: config.user,
          password: config.password)
        @conn.start
        @conn
      rescue Bunny::TCPConnectionFailedForAllHosts => e
        sleep(0.0001)
        retry
      rescue Bunny::TCPConnectionFailed => e
        sleep(0.0001)
        retry
      end
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
