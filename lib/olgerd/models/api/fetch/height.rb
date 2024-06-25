module ApiModule
  module Height
    def thorchain_lastblock_starter
      return unless thornode('json', 'thor', 'lastblock')

      @api.lastblock = determine_lastblock(@api.lastblock)

      Thormon.load

      Thread.new { compare_tip }
    end

    def determine_lastblock(json_data)
      json_data.is_a?(Array) ? json_data[0]['thorchain'] : json_data['thorchain'].to_i
    end

    def compare_tip
      response = Http::Client.json.get("#{@url.reference[:thor]}/lastblock")
      @api.tip = @api.lastblock - response.headers['x-thorchain-height'].to_i
      App.log.warn("#{logname} Stale TIP: #{@api.tip}") if @api.tip.negative?
    rescue StandardError => e
      App.err(e, __callee__)
    end
  end
end
