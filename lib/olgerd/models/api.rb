class Api
  include ApiModule::Packet

  attr_accessor :tip, :lastblock, :age, :blocktime, :stats, :tnetwork, :mnetwork,
                :chains, :balances, :nodes, :pools, :constants, :mimir, :churns

  def initialize
    @tip = 1
    @lastblock = 1
    @age = nil
    @blocktime = nil
    @stats = nil
    @tnetwork = nil
    @mnetwork = nil
    @chains = []
    @balances = {}
    @nodes = []
    @pools = []
    @constants = nil
    @mimir = nil
    @churns = []
  end
end
