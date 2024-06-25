class Protocol
  attr_accessor :versions

  def initialize(network)
    @network = network
    @versions = []
  end

  def determine_versions
    @versions = @network.api.nodes
                        .select { |node| ApiModule::Node.active?(node) }
                        .map { |node| node['version'] }.uniq
                        .map { |v| Gem::Version.new(v) }.sort
  end
end
