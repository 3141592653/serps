# coding: utf-8

module Serps
  class Search
    # Search Yahoo Smartphone Class
    class YahooSmartphone < self
      def initialize(options = {})
        @user_agent = AGENT[:sp]
        @uri = 'http://search.yahoo.co.jp/search'
        @delay = 2

        super options
      end

      def params_map
        { keyword: 'p' }
      end

      def send_request
        super
      rescue Mechanize::ResponseCodeError => e
        case e.response_code
        when /^50[03]$/
          server_error(e.response_code, e.page.uri)
        when /^999$/
          access_block(e.response_code, @page.uri)
        else
          raise
        end
      end

      def next_page
        paging = @page.link_with(text: /^\u6B21\u3078/)
        paging ? paging.click : nil
      end

      def extract_total
        @page.at('p.result').text.gsub(/[^0-9]/, '')
      end

      def extract_title(item)
        item.at('h2').text
      end
      alias_method :title, :extract_title

      def extract_url(item)
        parse_url item.at('h2/a').attr('href')
      end
      alias_method :url, :extract_url

      def parse_url(url)
        url =~ /^.+\*\*(http.+)$/ ? URI.unescape(Regexp.last_match[1]) : url
      end

      def extract_summary(item)
        item.at('p.smr').text
      end
      alias_method :summary, :extract_summary

      def extract_host(item)
        Addressable::URI.parse(extract_url(item)).host
      end
      alias_method :host, :extract_host

      def each_item
        @page.search('div.u01').each do |item|
          yield item
        end
      end
    end
  end
end
