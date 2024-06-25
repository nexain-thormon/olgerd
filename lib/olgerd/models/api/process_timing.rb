module ApiModule
  module ProcessTiming
    def calculate_timings
      return if @api.blocktime == 1

      current_time = Time.now
      age(current_time)
      blocktime(current_time)
    end

    private

    def age(current_time)
      @api.age = current_time - Time.at(@genesis)
    end

    def blocktime(current_time)
      reference_churn = timeframe(:penultimate)

      height_difference = @api.lastblock - reference_churn['height'].to_i
      return if height_difference.zero?

      churn_date = (reference_churn['date'].to_f / 1_000_000).round
      time_difference = (current_time.to_f * 1000).to_i - churn_date

      @api.blocktime = time_difference / (height_difference * 1000.0)
    end

    def timeframe(selector)
      return @api.churns.last if selector == :total
      return @api.churns.first if selector == :last

      @api.churns[1]
    end
  end
end
