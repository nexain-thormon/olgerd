require_relative 'boot'

module App
  class << self
    include Config::Banner
    include Config::Environment
    include Config::Geoip
    include Config::Heilsubrunnr
    include Config::Log
    include Config::Missing
    include Config::Networks
    include Config::Redis

    def load
      @config = {
        version: '1.0.0',
        networks: setup(%w[mainnet]),
        frequency: ENV.fetch('FREQUENCY', '4s'),
        timeout: ENV.fetch('TIMEOUT', 3),
        client: ENV.fetch('X_CLIENT_ID', 'THORmon'),
        log: log(ENV.fetch('LOG_COLOR', '') == 'enabled'),
        cycle: ENV.fetch('CYCLE', -1).to_i,
        production: production?,
        redis:,
        geoip:,
        heilsubrunnr:,
        banner:,
        status_order: Config::LIST['status_order'],
        chains: Config::LIST['chains']['active'],
        invalid_chains: Config::LIST['chains']['disabled'],
        isps: Config::LIST['isps'],
        keep: YAML.safe_load_file('config/item-whitelist.yml'),
        deny: {},
        wallets: YAML.safe_load_file('config/wallets.yml'),
        addresses: {}
      }.freeze

      def err(error, method)
        App.log.error("method: #{method} failed - Message: #{error.message}")
      end
    end
  end
end

App.load
Startup.message if App.banner
