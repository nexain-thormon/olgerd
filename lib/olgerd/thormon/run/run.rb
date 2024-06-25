module Thormon
  module Run
    class << self
      attr_accessor :rune

      def load
        data = Thormon::Skra.redis.get(App.redis[:key][:run])
        @rune = JSON.parse(data)&.slice(*App.keep['rune'])
      rescue StandardError => e
        App.err(e, __callee__)
      end
    end
  end
end
