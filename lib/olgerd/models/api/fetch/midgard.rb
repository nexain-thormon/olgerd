module ApiModule
  module Midgard
    def midgard_network
      return unless (response = thornode('json', 'midgard', 'network', 'mnetwork'))

      %w[activeBonds standbyBonds].each do |item|
        @api.mnetwork["#{item}Sum"] = response.body[item].map(&:to_i).reduce(:+)
      end
    end

    def midgard_stats
      thornode('json', 'midgard', 'stats')
    end

    def midgard_churns
      return unless thornode('bare', 'midgard', 'churns')

      @api.churns = JSON.parse(@api.churns)
      App.log.info("#{logname} CHURN: #{@api.churns.to_json}")
    end
  end
end
