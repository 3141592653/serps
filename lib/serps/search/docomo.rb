# coding: utf-8

module Serps
  class Search
    # Search Docomo Class
    class Docomo < self
      attr_reader :id, :scid, :tid, :pno

      def initialize(options = {})
        @user_agent = AGENT[:pc]
        @uri = 'http://imode-press.docomo.ne.jp/search'
        @pno = @id = @scid = @tid = '1'
        @delay = 0

        super options
      end

      def params
        super.map { |k, v| [k, v.encode('Shift_JIS')] }.to_h
      end

      def params_map
        { keyword: 'key', pno: 'pno', id: 'id', scid: 'scid', tid: 'tid' }
      end

      def send_request
        super
      rescue Mechanize::ResponseCodeError => e
        raise unless e.response_code =~ /^50[03]$/
        server_error(e.response_code, e.page.uri)
      end

      def next_page
        paging = @page.link_with(text: /^\u6B21\u30DA\u30FC\u30B8/)
        paging ? paging.click : nil
      end

      def extract_total
        total = @page.at('span.num').text
        total =~ /([0-9,]+)/ ? Regexp.last_match[1].delete(',') : nil
      end

      def extract_title(item)
        item.previous_element.text
      end
      alias_method :title, :extract_title

      def extract_url(item)
        parse_url item.at('div.linkMailto01/a').attr('href')
      end
      alias_method :url, :extract_url

      def parse_url(uri)
        uri =~ /body=(.+)$/ ? URI.unescape(Regexp.last_match[1]) : uri
      end

      def extract_summary(item)
        item.at('td/p').text
      end
      alias_method :summary, :extract_summary

      def extract_host(item)
        Addressable::URI.parse(extract_url(item)).host
      end
      alias_method :host, :extract_host

      def each_item
        @page.search('//table[@summary="info"]').each do |item|
          yield item
        end
      end
    end
  end
end
