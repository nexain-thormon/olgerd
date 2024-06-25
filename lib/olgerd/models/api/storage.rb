module ApiModule
  module Storage
    def store_data
      store_packet('nodes')
      store_packet('pools')
      sync_lastblock
    end

    def store_packet(packet)
      data = parcel(packet)

      if @buffer[packet.to_sym] == data
        App.log.info("#{logname} Redis #{packet.capitalize} not stored (no changes detected)")
        return
      end

      Thormon::Skra.redis.set("#{App.redis[:prefix]}_#{@name}_#{packet}", data)
      @buffer[packet.to_sym] = data

      App.log.info("#{logname} Redis Store > #{packet.capitalize}")
    rescue StandardError => e
      App.err(e, __callee__)
    end

    private

    def parcel(packet)
      data = @api.send("#{packet}_data")
      data.to_json
    end

    def sync_lastblock
      @buffer[:lastblock] = @api.lastblock
    end
  end
end
