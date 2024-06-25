module Thormon
  class << self
    def load
      threads = []

      threads << Thread.new { Thormon::Run.load }
      threads << Thread.new { Thormon::Hlekkir.load }
      threads << Thread.new { Thormon::Heilsubrunnr.load }

      threads.each(&:join)
    end
  end
end
