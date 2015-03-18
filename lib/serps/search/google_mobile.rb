# coding: utf-8

module Serps
  class Search
    # Search GoogleMobile Class
    class GoogleMobile < self
      def initialize(options = {})
        @user_agent = AGENT[:fp]
        @uri = 'https://www.google.co.jp/search'
        @delay = 30

        super options
      end

      def params_map
        { keyword: 'q' }
      end

      def send_request
        super
      rescue Mechanize::ResponseCodeError => e
        raise unless e.response_code =~ /^50[03]$/
        if e.page.uri.to_s =~ /google.com\/sorry/
          access_block(e.response_code, e.page.uri)
        else
          server_error(e.response_code, e.page.uri)
        end
      end

      def next_page
        paging = @page.link_with(text: /^\u6B21\u306E\u30DA\u30FC\u30B8/)
        paging ? paging.click : nil
      end

      def extract_total
      end

      def extract_title(item)
        item.at('div/a').text
      end
      alias_method :title, :extract_title

      def extract_url(item)
        url = parse_url item.at('div/a').attr('href')
        url.gsub(/\u203E/, '~')
      end
      alias_method :url, :extract_url

      def parse_url(uri)
        uri = uri =~ /^http/ ? uri : "http://www.google.co.jp#{uri}"
        uri = Addressable::URI.parse(uri)
        if uri.to_s =~ %r{^https?://www.google.co.jp/url}
          uri.query_values['q']
        elsif uri.to_s =~ %r{^https?://www.google.co.jp/gwt}
          uri.query_values['u'] || uri.to_s
        else
          uri.to_s
        end
      end

      def extract_summary(item)
        item.at('div[2]/div').remove if item.at('div[2]/div')
        item.at('div[2]').text if item.at('div[2]')
      end
      alias_method :summary, :extract_summary

      def extract_host(item)
        Addressable::URI.parse(extract_url(item)).host
      end
      alias_method :host, :extract_host

      def each_item
        items = @page / '//div[@class="web_result" or @class="video_result"]'
        items.each do |item|
          next if item.at('div/a').nil?
          yield item
        end
      end
    end
  end
end
