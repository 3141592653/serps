require 'serps'
require 'thor'

module Serps
  # Serps CLI Task Class
  class CLI < Thor
    desc 'yahoo', 'search yahoo pc'
    def yahoo
      interactive Serps::Search::Yahoo
    end

    desc 'yahoo_smartphone', 'search yahoo smartphone'
    def yahoo_smartphone
      interactive Serps::Search::YahooSmartphone
    end

    desc 'google_mobile', 'search google mobile'
    def google_mobile
      interactive Serps::Search::GoogleMobile
    end

    desc 'docomo', 'search docomo'
    def docomo
      interactive Serps::Search::Docomo
    end

    private

    def keyword
      print 'keyword: '
      $stdin.gets.chomp.encode('UTF-8')
    end

    def count
      print 'count: '
      count = $stdin.gets.chomp.to_i
      count == 0 ? 10 : count
    end

    def interactive(serps_class)
      params = { progress: true, keyword: keyword, count: count }

      agent = serps_class.new params
      agent.search

      puts agent.totalcount
      agent.items.each do |item|
        puts [item.rank, item.uri].join("\t")
      end
    rescue => e
      puts e.message
    end
  end
end
