require 'scamp/plugin'
require 'twitter'

class TwitterPlugin < Scamp::Plugin
  match /https?:\/\/twitter.com(?:\/#!)?\/[\w-]+\/status(?:es)?\/(?<tweet_id>\d+)/i, :tweet
  match /https?:\/\/twitter\.com(?:\/#!)?\/(?<username>[^\/]+?)(?:$|\s)/i, :user

  def tweet channel, msg
    begin
      tweet = Twitter.status(msg.matches.tweet_id)
      user = tweet.user
    rescue Twitter::Error => e
      puts "Caught #{e}"
    end
    channel.say "#{CGI.unescapeHTML(tweet.text.gsub(/\n+/m, " \\n "))} - #{user.name} (#{user.screen_name})" if tweet 
  end

  def user channel, msg
    begin
      u = Twitter.user(msg.matches.username)
      channel.say "#{u.name} (#{u.screen_name}) - #{u.description} #{u.profile_image_url}"
      channel.say "Last status: #{CGI.unescapeHTML(u.status.text.gsub(/\n+/m, " \\n "))}"
    rescue => e
      puts "Caught #{e}"
    end
  end
end
