module Thormon
  module Heilsubrunnr
    class << self
      def load
        @health = {}
        CSV.parse(fetch, headers: true) { |row| process(row) if valid?(row) }
      end

      def attach!(nodes, net)
        nodes.each do |node|
          next if node['ip_address'].to_s.empty?

          node[:health] = @health.dig(net, node['ip_address']) || brunnr[:default]
        end
      end

      private

      def fetch
        Http::Client.heilsubrunnr.get.body
      rescue StandardError => e
        App.err(e, __callee__)
        ''
      end

      def process(row)
        network_service, ip, code = row.values_at(0, 1, 17)
        network, service = network_service.split(brunnr[:delimiter])

        @health[network] ||= {}
        @health[network][ip] ||= {}
        @health[network][ip][service] = code
      end

      def brunnr
        App.heilsubrunnr[:health]
      end

      def valid?(row)
        row[1] != 'BACKEND' && brunnr[:services].any? { |svc| row[0].include?("#{brunnr[:delimiter]}#{svc}") }
      end
    end
  end
end
