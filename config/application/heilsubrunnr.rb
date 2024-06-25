module Config
  module Heilsubrunnr
    private

    def heilsubrunnr
      {
        health: {
          delimiter: LIST['health']['delimiter'],
          services: LIST['health']['services'].keys,
          default: default_health
        },
        url: ENV['HEILSUBRUNNR_URL'],
        user: ENV['HEILSUBRUNNR_USER'],
        pass: ENV['HEILSUBRUNNR_PASS'],
        host: ENV.fetch('HEILSUBRUNNR_HOST', 'thorchain.network'),
        agent: ENV.fetch('HEILSUBRUNNR_AGENT', 'THORmon Heilsubrunnr'),
        port: ENV.fetch('HEILSUBRUNNR_PORT', 9000).to_i,
        svc: LIST['health']['services']
      }
    end

    def default_health
      LIST['health']['services'].keys.to_h { |svc| [svc, LIST['health']['placeholder']] }.freeze
    end
  end
end
