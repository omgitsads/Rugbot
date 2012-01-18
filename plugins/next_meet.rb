require 'scamp/plugin'
require 'date'

class NextMeetPlugin < Scamp::Plugin
  match /^nextmeet$/i, :next_meet
  match /^nextmeat$/i, :next_meat

  def next_meat channel, msg
    channel.say "BACNOM"
  end

  def next_meet channel, msg
    nwrug, *details = meeting_details

    puts "#{nwrug.inspect}, #{details.inspect}"

    # In case we couldn't parse a current time from the website
    nwrug ||= nwrug_meet_for Time.now.year, Time.now.month

    date_string = case nwrug
    when Date.today
      "Today"
    when (Date.today + 1)
      "Tomorrow"
    else
      nwrug.strftime("%A, #{ordinalize(nwrug.day)} %B")
    end

    # compact makes sure we don't end up with "Today - ", but "Today" instead.
    channel.say [date_string, details].compact.join(" - ")
  end

  def meeting_details
    # Grab ze string from ze website
    event = Nokogiri::HTML(Curl::Easy.perform("http://nwrug.org/events/").body_str).css('.first_entry h3').first
    entry_url = "http://nwrug.org#{event.css('a').first.attributes['href'].value}"
    entry_title = event.content.force_encoding("ASCII-8BIT").gsub("\342\200\223","-").strip

    puts entry_title

    # Figure out the details we want to return
    meeting_date, *meeting_title = entry_title.split(" - ")
    meeting_title = meeting_title.join(" - ")

    puts "#{meeting_date.inspect} - #{meeting_title}"

    if (d = Date.parse(meeting_date)) && d >= Date.today
      return [d, meeting_title, entry_url]
    else
      return [nil, nil, nil]
    end
  end

  def nwrug_meet_for year, month
    beginning_of_month = Date.civil(year, month, 1)
    nwrug = beginning_of_month + (18 - beginning_of_month.wday)
    nwrug += 7 if beginning_of_month.wday > 4

    # Make sure we skip to the next month if we've gone past this month's meet
    if nwrug < Date.today
      if month == 12
        month = 1
        year += 1
      else
        month += 1
      end
      nwrug = nwrug_meet_for year, month
    end

    nwrug
  end

end
