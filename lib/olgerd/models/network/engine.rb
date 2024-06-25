module NetworkModule
  module Engine
    def initialize_engine
      @scheduler = Rufus::Scheduler.new
      @mutex = Mutex.new
      @counter = 0
    end

    def run
      Thormon::Skra.wait(-> { piston })
    end

    def piston
      @scheduler.every App.frequency do
        @mutex.synchronize do
          generator
        end
      end
      @scheduler.join
    end
  end
end
