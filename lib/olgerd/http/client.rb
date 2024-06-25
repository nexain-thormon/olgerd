module Http
  module Client
    class << self
      def bare
        @bare ||= create_connection(headers: client_headers)
      end

      def json
        @json ||= create_connection(headers: client_headers) do |conn|
          conn.response :json
        end
      end

      def geoip
        @geoip ||= create_connection(headers: geoip_headers) do |conn|
          conn.response :json
        end
      end

      def heilsubrunnr
        @heilsubrunnr ||= create_connection(url: App.heilsubrunnr[:url]) do |conn|
          conn.request :authorization, :basic, App.heilsubrunnr[:user], App.heilsubrunnr[:pass]
        end
      end

      private

      def client_headers
        { 'X-Client-ID' => App.client }
      end

      def geoip_headers
        { 'User-Agent' => App.geoip[:agent] }
      end

      def create_connection(url: nil, headers: {}, &block)
        headers['User-Agent'] ||= "THORmon Olgerd/#{App.version}"
        Faraday.new(url:) do |conn|
          conn.options.timeout = App.timeout
          conn.options.open_timeout = App.timeout
          conn.headers.update(headers)
          block&.call(conn)
        end
      end
    end
  end
end
