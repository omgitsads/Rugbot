require 'scamp/plugin'

class MustachifyPlugin < Scamp::Plugin
  match /(?:mus)?tas?ch(?:e|ify) (?<url>http.*)$/, :mustachify_url
  match /(?:mus)?tas?ch(?:e|ify) (?<phrase>.*)$/, :mustachify_phrase

  def mustachify_url channel, msg
    channel.say tasche(msg.matches.url)
  end

  def mustachify_phrase channel, msg
    img = image_for(msg.matches.phrase)
    channel.say (img ? tasche(img) : "Nothing found")
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

    def tasche url
      "http://mustachify.me/?src=#{CGI::escape(url)}"
    end
end
