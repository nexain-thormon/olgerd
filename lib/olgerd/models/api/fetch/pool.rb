module ApiModule
  module Pool
    def thorchain_pools
      prune_keys!(@api.pools) if thornode('json', 'thor', 'pools')
    end

    def prune_keys!(pools)
      pools.each { |pool| pool.delete('short_code') }
    end
  end
end
