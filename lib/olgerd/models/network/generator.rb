module NetworkModule
  module Generator
    def generator
      @counter += 1

      exit if !App.production && App.cycle != -1 && @counter > App.cycle

      return App.log.error("#{logname} Redis Connection failure") unless Thormon::Skra.connection?

      threads = []

      threads << Thread.new { thorchain_lastblock_starter }
      threads << Thread.new { thorchain_constants }
      threads << Thread.new { thorchain_mimir }
      threads << Thread.new { midgard_network }
      threads << Thread.new { midgard_stats }
      threads << Thread.new { thorchain_network }
      threads << Thread.new { thorchain_nodes }
      threads << Thread.new { midgard_churns }
      threads << Thread.new { thorchain_pools }
      threads << Thread.new { fetch_balances }

      threads.each(&:join)

      process_data

      return App.log.info("#{logname} Block Height unchanged - skip processing") unless outdated?

      store_data
    end
  end
end
