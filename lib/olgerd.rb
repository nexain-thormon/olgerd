require_relative '../config/application'

trap('INT') do
  puts 'Shutting down...'
  App.networks.each { |network| network.scheduler.shutdown(:wait) }
  exit
end

def start
  Thormon.load
  App.networks.each(&:run)
end

Thormon::Skra.wait(-> { start })
