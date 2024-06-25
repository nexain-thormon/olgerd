module Thormon
  module Skra
    class << self
      def redis
        @redis ||= Redis.new(url: App.redis[:url])
      end

      def connection?
        redis.ping == 'PONG'
      rescue Redis::BaseConnectionError
        false
      end

      def wait(callable = nil)
        msg = false

        loop do
          callable.call and break if Thormon::Skra.connection?

          App.log.warn('Waiting for redis connection...') and msg = true unless msg
          sleep(App.redis[:retry])
        end
      end
    end
  end
end
