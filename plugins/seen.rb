require 'scamp/plugin'

class SeenPlugin < Scamp::Plugin
  match /^seen (?<seen_user>\w+)$/i, :seen
  match /.*/, :seen_capture

  SEEN_LIST = {}

  def seen channel, msg
    if SEEN_LIST.has_key?(msg.matches.seen_user)
      channel.reply "I last saw #{msg.matches.seen_user} speak at #{SEEN_LIST[msg.matches.seen_user].strftime("%H:%M:%S on %d-%m-%y")}"
    else
      channel.reply "not seen #{msg.matches.seen_user} yet, sorry"
    end
  end

  def seen_capture channel, msg
    SEEN_LIST[msg.user] = Time.now
  end
end
