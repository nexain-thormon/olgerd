module ApiModule
  module ProcessChain
    def calculate_chains
      return if @api.blocktime == 1

      @api.chains = []
      observe_chains = @api.nodes.select { |n| Node.active?(n) }.map { |n| n['observe_chains'] }

      App.chains.each do |chain|
        max = 0
        observe_chains.each do |oc|
          pick = oc.select { |x| x['chain'] == chain }[0]

          next if pick.nil?

          cur = pick['height']
          max = [cur, max].max
        end
        @api.chains.push({ name: chain, max: })
      end
    end
  end
end
