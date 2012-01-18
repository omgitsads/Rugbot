require 'scamp/plugin'

class UrlPlugin < Scamp::Plugin
  match /(?<url>https?:\/\/\S+)/i, :url

  def url channel, msg
    begin
      easy = Curl::Easy.perform(msg.matches.url) do |easy|
        easy.follow_location = true # follow redirects
      end

      title = Nokogiri::HTML(easy.body_str).css('title').first.content
      channel.say "#{title.gsub(/\s+/m, " ").strip}"
    rescue StandardError => e
      puts "general http link got error: #{e}"
    end
  end
end
