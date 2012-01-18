require 'scamp/plugin'

class SystemPlugin < Scamp::Plugin
  match /^ram\s$/i, :ram
  match /^uptime\s*$/i, :uptime

  def ram channel, msg
    usage = `ps -p #{Process.pid} -o rss=`.strip.chomp.to_i
    channel.reply ("current usage is %.2f MB" % (usage/1024.0))
  end

  def uptime channel, msg
    start_time = Time.parse(`ps -p #{Process.pid} -o lstart=`.strip.chomp)
    channel.reply "I've been running for #{(Time.now - start_time).to_time_length}"
  end
end
