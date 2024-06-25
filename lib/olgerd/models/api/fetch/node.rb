module ApiModule
  module Node
    class << self
      def active?(node)
        node['status'].casecmp?('Active')
      end
    end

    def thorchain_nodes
      return unless thornode('json', 'thor', 'nodes')

      @protocol.determine_versions

      @api.nodes = @api.nodes
                       .reject { |node| invalid_address?(node) }
                       .map { |node| node.slice(*App.keep['node']) }
                       .tap { |x| process_nodes!(x) }
                       .sort_by { |node| sort_criteria(node) }
                       .tap(&:reverse!)

      Thread.new { Thormon::Hlekkir.store_nodes(@api.nodes, @name) }
    end

    def invalid_address?(node)
      node['node_address'].to_s.empty? || blacklistable?(node)
    end

    private

    def process_nodes!(nodes)
      sanitize_passive_nodes!(nodes)
      sanitize_chains!(nodes)
      sanitize_vaults!(nodes)
      sanitize_jails!(nodes, @api.lastblock)
      Http::Geoip.attach!(nodes, logname)
      Thormon::Hlekkir.attach!(nodes)
      Thormon::Heilsubrunnr.attach!(nodes, @name)
    end

    def sanitize_passive_nodes!(nodes)
      nodes.each do |node|
        %w[observe_chains current_award].each do |key|
          node.delete(key) unless Node.active?(node)
        end
      end
    end

    def sanitize_chains!(nodes)
      nodes.each do |node|
        chains = node['observe_chains'] || []
        node['observe_chains'] = chains.reject { |c| App.invalid_chains.include?(c['chain']) }
      end
    end

    def sanitize_vaults!(nodes)
      nodes.each do |node|
        node['vault'] = node['signer_membership'].last if Node.active?(node)
        node.delete('signer_membership')
      end
    end

    def sanitize_jails!(nodes, lastblock)
      nodes.each do |node|
        node.delete('jail') if node['jail']&.dig('release_height').to_i <= lastblock
      end
    end

    def blacklistable?(node)
      (!Node.active?(node) || !@protocol.versions.include?(node['version'])) &&
        App.deny['nodes']&.include?(node['node_address'])
    end

    def sort_criteria(node)
      status_index = App.status_order.index(node['status'].upcase)
      [-status_index, Gem::Version.new(node['version']), node['total_bond'].to_i]
    end
  end
end
