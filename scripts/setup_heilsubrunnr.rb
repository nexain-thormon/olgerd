require_relative 'base'

CFG = './heilsubrunnr/heilsubrunnr.cfg'.freeze

networks = {}

App.networks.each do |net|
  nodes = Script.pull_nodes(net)

  networks = {
    net.name => {
      svc: App.heilsubrunnr[:svc],
      servers: nodes.group_by { |node| node['ip_address'] }
                    .map { |_ip, nodes_group| nodes_group.min_by { |node| node['status_since'] } }
                    .map { |node| node.slice(*%w[node_address ip_address]) }
    }
  }
end

Script.write_file(CFG, ERB.new(File.read("#{CFG}.erb"), trim_mode: '-').result(binding), eol: false)
