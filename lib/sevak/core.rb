module Sevak
  module Core
    def connection
      ::Sevak.establish_connection
    end

    def config
      ::Sevak.config
    end
  end
end