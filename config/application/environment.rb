module Config
  module Environment
    private

    def production?
      ENV['APP_ENV'] == 'production'
    end
  end
end
