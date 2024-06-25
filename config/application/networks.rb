module Config
  module Networks
    private

    def setup(networks)
      networks.map do |network|
        net = network.upcase
        Network.new(name: network,
                    genesis: ENV["#{net}_GENESIS"],
                    url: {
                      thor: ENV["#{net}_URL_THOR"],
                      midgard: ENV["#{net}_URL_MIDGARD"],
                      reference: ENV["#{net}_URL_THOR_REFERENCE"]
                    })
      end
    end
  end
end
