require 'scamp/plugin'

class ImagemePlugin < Scamp::Plugin
  match /^artme (?<phrase>.*?)$/i, :artme
  match /^imageme (?<phrase>.*?)$/i, :artme

  def artme channel, msg
    response = image_for(msg.matches.phrase)
    channel.say (response ? response : "Nothing found")
  end

  private
    def image_for phrase
      if phrase == 'random'
        lns = File.readlines("/usr/share/dict/words")
        phrase = lns[rand(lns.size)].strip
      end

      begin
        url = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&safe=off&q=#{CGI::escape(phrase)}"
        doc = JSON.parse(Curl::Easy.perform(url).body_str)
        URI::unescape(doc["responseData"]["results"][0]["url"])
      rescue
        nil
      end
    end
end
