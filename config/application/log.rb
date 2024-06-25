module Config
  module Log
    private

    def log(colored)
      logger = Logger.new($stdout)

      transform = {
        'DEBUG' => ['DBG', "\e[34m"],   # Blue
        'INFO' => ['INF', "\e[32m"],    # Green
        'WARN' => ['WRN', "\e[33m"],    # Yellow
        'ERROR' => ['ERR', "\e[31m"],   # Red
        'FATAL' => ['FTL', "\e[35m"],   # Magenta
        'UNKNOWN' => ['UNK', "\e[37m"]  # White
      }

      reset = "\e[0m"

      logger.formatter = proc do |severity, datetime, _, msg|
        timestamp = datetime.utc.strftime('%Y-%m-%dT%H:%M:%SZ')

        rigidity = transform[severity][0] || 'UNK'
        paint = transform[severity][1] || "\e[37m"

        colors = "#{timestamp} #{paint}#{rigidity}#{reset} #{msg}\n"
        plain = "#{timestamp} #{rigidity} #{msg}\n"

        colored ? colors : plain
      end

      logger
    end
  end
end
