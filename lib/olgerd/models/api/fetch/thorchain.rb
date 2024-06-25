module ApiModule
  module Thorchain
    def thorchain_network
      thornode('json', 'thor', 'network', 'tnetwork')
    end

    def thorchain_constants
      return unless thornode('bare', 'thor', 'constants')

      @api.constants = JSON.parse(@api.constants).values.reduce({}, :merge)
      App.log.info("#{logname} CONSTANTS: #{@api.constants.to_json}")
    end

    def thorchain_mimir
      return unless thornode('bare', 'thor', 'mimir')

      @api.mimir = JSON.parse(@api.mimir)
      App.log.info("#{logname} MIMIR: #{@api.mimir.to_json}")
    end
  end
end
