require 'mechanize'
require 'addressable/uri'
require 'ruby-progressbar'
require 'serps/search/base'

module Serps
  # Serps Search Class
  class Search
    autoload :Yahoo, 'serps/search/yahoo'
    autoload :YahooSmartphone, 'serps/search/yahoo_smartphone'
    autoload :GoogleMobile, 'serps/search/google_mobile'
    autoload :Docomo, 'serps/search/docomo'
  end
end
