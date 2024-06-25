module ApiModule
  module Balance
    def fetch_balances
      fetch_supply
      App.wallets['balances'].each do |name, wallet|
        fetch_balance(name, :midgard, wallet)
      end
    end

    private

    def fetch_supply
      response = Http::Client.json.get("#{@url.cosmos}/bank/v1beta1/supply/rune")
      @api.balances['supply'] = response.body['amount']['amount']
    rescue StandardError => e
      App.err(e, __callee__)
    end

    def fetch_balance(name, service, wallet)
      response = Http::Client.json.get("#{@url.public_send(service)}/balance/#{wallet}")
      @api.balances[name] = pick_rune(response.body)
    rescue StandardError => e
      App.err(e, __callee__)
    end

    def pick_rune(wallet)
      wallet['coins'].find { |coin| coin['asset'] == 'THOR.RUNE' }&.fetch('amount', nil)
    end
  end
end
