require 'fileutils'
require 'erb'

require_relative '../config/application'

module Script
  class << self
    def write_file(path, content, eol: true)
      content = "#{content}\n" if eol
      File.write(path, content)
    end

    def pull_nodes(net)
      Http::Client.json.get("#{net.url.thor}/nodes").body.reject { |n| validate_nodes(net, n) }
    end

    private

    def validate_nodes(net, node)
      net.invalid_address?(node) || !Http::Tool.valid_public_ip?(node['ip_address'])
    end
  end
end
