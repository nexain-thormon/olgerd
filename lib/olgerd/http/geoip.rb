module Http
  module Geoip
    class << self
      def attach!(nodes, logname)
        nodes.each do |node|
          ip = node['ip_address']

          next unless Http::Tool.valid_public_ip?(ip)

          if App.addresses.key?(ip)
            node['geoip'] = App.addresses[ip].except(:register) if App.addresses[ip].key?(:register)
            next
          end

          App.addresses[ip] = fetch_geo_info(ip)
          node['geoip'] = App.addresses[ip].except(:register)

          App.log.info("#{logname} Geoip #{{ ip => node['geoip'] }.to_json}")
        end
      end

      private

      def fetch_geo_info(ip)
        response = fetch_geo_response(ip)
        parse_geo_response(response)
      rescue StandardError => e
        App.err(e, __callee__)
        {}
      end

      def fetch_geo_response(ip)
        Http::Client.geoip.get("#{App.geoip[:url]}#{ip}").body.dig('data', 'geo')
      end

      def parse_geo_response(response)
        {
          isp: resolve_isp_name(response['isp']),
          cc: response['country_code'],
          city: response['city'],
          register: true
        }
      end

      def resolve_isp_name(isp)
        isp.upcase!
        return 'VULTR' if isp.include?('CHOOPA')
        return 'ZENLAYER' if isp.include?('ZEN')

        App.isps.detect { |i| isp.include?(i.upcase) } || isp
      end
    end
  end
end
