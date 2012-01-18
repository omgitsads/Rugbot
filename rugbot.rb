#encoding: utf-8
require 'rubygems'
require "bundler/setup"

# Why yes, let's be astonishingly lazy
Bundler.require :default

require File.expand_path("rugbot_helper", File.dirname(__FILE__))

BOT_NAME = 'rugbot2'
BOT_REPO = 'caius/Rugbot'
SEEN_LIST = {}
IMGUR_API_KEY = "4cdab1b0d1c8831232d477302a981363"
TASCHE = /(?:mus)?tas?ch(?:e|ify)/

require 'scamp/irc'

require './plugins/mustachify'
require './plugins/command_list'
require './plugins/next_meet'
require './plugins/imageme'
require './plugins/twitter'
require './plugins/system'
require './plugins/url'
require './plugins/seen'

Scamp.new :verbose => true do |bot|
  bot.adapter :irc, Scamp::IRC::Adapter,  :server => 'irc.freenode.net',
                                          :port => 6667,
                                          :nick => BOT_NAME,
                                          :channels => ['nwrug']

  bot.plugin MustachifyPlugin
  bot.plugin CommandListPlugin
  bot.plugin NextMeetPlugin
  bot.plugin ImagemePlugin
  bot.plugin TwitterPlugin
  bot.plugin UrlPlugin
  bot.plugin SystemPlugin
  bot.plugin SeenPlugin

  bot.match /^stats?$/ do |channel,msg|
    channel.say "http://dev.hentan.eu/irc/nwrug.html"
  end

  bot.match /^dance$/i do |channel,msg|
    case [0,1,2].shuffle.first
    when 0
      channel.say "EVERYBODY DANCE NOW!"
      channel.action "does the funky chicken"
    when 1
      channel.say "http://no.gd/caiusboogie.gif"
    when 2
      channel.say "http://i.imgur.com/rDDjz.gif"
    end
  end

  bot.match /^troll(face)?$/i do |channel, msg|
    channel.say ["http://no.gd/troll.png", "http://no.gd/trolldance.gif", "http://caius.name/images/phone_troll.jpg"].shuffle.first
  end

  bot.match /^boner/i do |channel, msg|
    channel.say ["http://files.myopera.com/coxy/albums/106123/trex-boner.jpg", "http://no.gd/badger.gif"].shuffle.first
  end

  bot.match /^badger/i do |channel, msg|
    channel.say "http://no.gd/badger2.gif"
  end

  bot.match /dywj/i do |channel, msg|
    channel.say "DAMN YOU WILL JESSOP!!!"
  end

  bot.match /^roll ([0-9]*)$/i do |channel, msg|
    sides = msg.matches[0].to_i || 6
    channel.say "#{msg.user} rolls a #{sides} sided die and gets #{rand(sides) +1}"
  end

  bot.match /ACTION(.*)pokes #{Regexp.escape(BOT_NAME)}/i do |channel, msg|
    channel.action "giggles at #{msg.user}"
  end

  bot.match /^37status$/i do
   doc = JSON.parse(Curl::Easy.perform('http://status.37signals.com/status.json').body_str)
   channel.say "#{doc['status']['mood']}: #{doc['status']['description']}"
  end

  bot.match /^.* st[aа]bs/i do |channel, msg|
    channel.action "stabs #{msg.user}"
  end

  bot.match /^stab (?<person>.*?)$/i do |channel, msg|
    user = (BOT_NAME if [BOT_NAME, "self", "yourself"].include?(msg.user)) || msg.user
    channel.action "stabs #{user}"
  end

  bot.match /^b(oo|ew)bs$/i do |channel, msg|
    channel.say ["(.)(.)", "http://no.gd/boobs.gif"].shuffle.first
  end

  bot.connect!
end
