require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '1m' do
#  Channel.all.each { |c| c.update }
end
