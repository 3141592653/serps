# coding: utf-8

module Serps
  class Search
    # Search Yahoo Class
    class Yahoo < self
      def initialize(options = {})
        @user_agent = AGENT[:pc]
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
        total = @page.search('div#inf').text
        total =~ /\u7D04([0-9,]+)\u4EF6/ ? Regexp.last_match[1].delete(',') : nil
      end

      def extract_title(item)
        item.at('a').text
      end
      alias_method :title, :extract_title

      def extract_url(item)
        escape_url item.at('a').attr('href')
      end
      alias_method :url, :extract_url

      def escape_url(url)
        url =~ /^.+\*\*(http.+)$/ ? URI.unescape(Regexp.last_match[1]) : url
      end

      def extract_summary(item)
        item.at('div').text
      end
      alias_method :summary, :extract_summary

      def extract_host(item)
        Addressable::URI.parse(extract_url(item)).host
      end
      alias_method :host, :extract_host

      def each_item
        @page.search('div#web/ol/li').each do |item|
          yield item
        end
      end
    end
  end
end
