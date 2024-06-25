module Config
  module Redis
    private

    def redis
      {
        url: redis_url,
        retry: ENV.fetch('REDIS_RETRY', 1).to_i,
        prefix: ENV.fetch('REDIS_PREFIX', 'thormon_olgerd'),
        key: {
          run: ENV.fetch('RUN_PREFIX', 'thormon_run_thorchain'),
          hlekkir: ENV.fetch('HLEKKIR_PREFIX', 'thormon_hlekkir')
        }
      }
    end

    def redis_url
      ENV.fetch('REDIS_URL') do
        ENV['APP_ENV'] == 'production' ? 'redis://redis:6379/0' : 'redis://localhost:6379/0'
      end
    end
  end
end
