module Startup
  def self.message
    puts File.read('.banner')
    puts "                       Ölgerð #{App.version}"
    puts
    puts "NETWORKS     #{App.networks.map(&:name).join(' ')}"
    puts "FREQUENCY    #{App.frequency}"
    puts "TIMEOUT      #{App.timeout}"
    puts "CLIENT       #{App.client}"
    puts "CHAINS       #{App.chains.join(' ')}"
    puts "SKRÁ         #{Thormon::Skra.connection? ? 'Good' : 'Bad'} connection to #{App.redis[:url]}"
    puts
  end
end
