module Http
  module Tool
    class << self
      def valid_public_ip?(ip)
        ip_addr = IPAddr.new(ip)
        !ip_addr.private?
      rescue IPAddr::InvalidAddressError
        false
      end
    end

    private

    def thornode(client, service, endpoint, override = nil)
      url = "#{@url.send(service)}/#{endpoint}"
      response = Http::Client.send(client).get(url)
      App.log.info("#{logname} Fetch #{service.upcase}[#{endpoint}]: Success") if response.success?

      return nil if service == 'thor' && stale?(response.headers, service, endpoint)

      attribute = override || endpoint
      @api.send("#{attribute}=", whitelist(response.body, attribute))
      response
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError, Faraday::SSLError => e
      App.log.error("#{logname} Fetch #{service.upcase}[#{endpoint}]: Connection issues: #{e.message}")
      nil
    rescue Faraday::Error => e
      App.log.error("#{logname} Fetch #{service.upcase}[#{endpoint}]: Client error: #{e.message}")
      nil
    rescue StandardError => e
      App.log.error("#{logname} Fetch #{service.upcase}[#{endpoint}]: Unexpected error: #{e.message}")
      nil
    end

    def whitelist(body, attribute)
      attrs = App.keep[attribute] if App.keep.key?(attribute)
      attrs ? body.slice(*attrs) : body
    end

    def stale?(headers, service, endpoint)
      blockheight = headers['x-thorchain-height'].to_i

      return false unless @api.lastblock.is_a?(Integer) && blockheight < @api.lastblock

      App.log.info("#{logname} Stale #{service.upcase}[#{endpoint}] is #{@api.lastblock - blockheight} block/s behind")

      true
    end
  end
end
