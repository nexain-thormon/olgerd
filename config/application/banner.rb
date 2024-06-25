module Config
  module Banner
    private

    def banner
      return true if ENV['BANNER'] == 'enabled'
      return false unless ENV['BANNER'].nil?

      !production?
    end
  end
end
