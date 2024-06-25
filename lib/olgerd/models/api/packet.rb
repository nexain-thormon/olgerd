module ApiModule
  module Packet
    def nodes_data
      {
        version: App.version,
        rune: Thormon::Run.rune,
        tip: @tip,
        lastblock: @lastblock,
        age: @age,
        blocktime: @blocktime,
        stats: @stats,
        network: @tnetwork,
        mnetwork: @mnetwork,
        chains: @chains,
        balances: @balances,
        nodes: @nodes
      }.tap do |hash|
        hash[:constants] = @constants unless @constants.nil?
        hash[:mimir] = @mimir unless @mimir.nil?
        hash[:churns] = @churns unless @churns.empty?
      end
    end

    def pools_data
      {
        version: App.version,
        rune: Thormon::Run.rune,
        tip: @tip,
        lastblock: @lastblock,
        chains: @chains,
        pools: @pools
      }.tap do |hash|
        hash[:constants] = @constants unless @constants.nil?
        hash[:mimir] = @mimir unless @mimir.nil?
        hash[:churns] = @churns unless @churns.empty?
      end
    end
  end
end
