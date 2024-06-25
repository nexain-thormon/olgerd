module Thormon
  module Hlekkir
    class << self
      def probes
        @probes ||= {}
      end

      def [](node_address)
        probes[node_address]
      end

      def load
        App.networks.map(&:name).each do |net|
          redis_data = fetch_data(net)
          parsed_data = parse_data(redis_data)
          probes.merge!(parsed_data)
        end
      rescue JSON::ParserError, KeyError => e
        App.err(e, __callee__)
      end

      def attach!(nodes)
        nodes.each { |node| node['probes'] = probes[node['node_address']] }.compact!
      end

      def store_nodes(nodes, net)
        Thormon::Skra.redis.set("#{App.redis[:prefix]}_#{net}_hlekkir", hlekkir_nodes(nodes))
      rescue StandardError => e
        App.err(e, __callee__)
      end

      private

      def fetch_data(net)
        Thormon::Skra.redis.get("#{App.redis[:key][:hlekkir]}_#{net}") || '{}'
      end

      def parse_data(redis_data)
        JSON.parse(redis_data)
            .transform_values { |chains| process_chains(chains) }
      end

      def process_chains(chains)
        chains.except('THOR', 'timestamp').transform_values do |details|
          details['block_scanner_height'] - details['chain_height']
        end
      end

      def hlekkir_nodes(nodes)
        nodes.filter_map do |node|
          next if node['node_address'].to_s.empty?
          next unless Http::Tool.valid_public_ip?(node['ip_address'])

          node.slice('node_address', 'ip_address')
        end.to_json
      end
    end
  end
end
