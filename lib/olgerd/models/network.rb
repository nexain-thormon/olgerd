class Network
  include ApiModule::Balance
  include ApiModule::Height
  include ApiModule::Midgard
  include ApiModule::Node
  include ApiModule::Pool
  include ApiModule::Process
  include ApiModule::ProcessChain
  include ApiModule::ProcessTiming
  include ApiModule::Storage
  include ApiModule::Thorchain
  include Http::Tool
  include NetworkModule::Buffer
  include NetworkModule::Engine
  include NetworkModule::Generator
  include NetworkModule::Log

  attr_reader :name, :genesis, :protocol, :url
  attr_accessor :scheduler, :mutex, :api, :counter, :buffer

  def initialize(name:, genesis:, url:)
    initialize_buffer
    initialize_engine
    @name = name
    @genesis = genesis.to_i / 1000
    @protocol = Protocol.new(self)
    @url = Url.new(url:)
    @api = Api.new
  end
end
