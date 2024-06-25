module Config
  module Missing
    private

    def method_missing(name, *args, &)
      return @config[name] if @config.key?(name)

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      @config.key?(method_name) || super
    end
  end
end
