module Config
  module Geoip
    private

    def geoip
      {
        url: ENV['GEOIP_URL'],
        agent: ENV['GEOIP_AGENT']
      }
    end
  end
end
