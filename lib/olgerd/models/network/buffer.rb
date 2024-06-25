module NetworkModule
  module Buffer
    def initialize_buffer
      @buffer = {
        lastblock: 1,
        nodes: nil,
        pools: nil
      }
    end

    def outdated?
      @buffer[:lastblock] < @api.lastblock
    end
  end
end
