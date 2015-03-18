# coding: utf-8

module Serps
  # Search Base Class
  class Search
    class NotFound < StandardError; end
    class ServerError < StandardError; end
    class AccessBlock < StandardError; end

    AGENT = {
      pc: 'Mozilla/5.0',
      fp: 'DoCoMo/2.0 P903i(c100;TB;W24H12',
      sp: 'Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53'
    }

    attr_reader :keyword
    attr_reader :count
    attr_reader :offset

    attr_reader :items
    attr_reader :totalcount

    attr_accessor :agent

    def initialize(options = {})
      @keyword = options.delete(:keyword)
      @count = options.delete(:count).to_i || 10
      @progress = options.delete(:progress) || false

      @agent = Mechanize.new options.delete(:agent)
      @agent.user_agent = @user_agent
      @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

      @retry_level = 3
    end

    def params
      Hash[*params_map.invert.map { |name, value| [name, send(value)] }.flatten]
    end

    def generate_uri
      uri = Addressable::URI.parse(@uri)
      uri.query_values = params
      uri
    end

    def send_request
      @retry_level -= 1
      @page = @page ? next_page : base_page
      @retry_lavel = 3
      sleep @delay
    rescue Mechanize::ResponseCodeError => e
      raise unless e.response_code =~ /^40[0134]$/
      not_found(e.response_code, e.page.uri)
    end

    def base_page
      @agent.get(generate_uri)
    end

    def extract_rank
      items.size + 1
    end
    alias_method :rank, :extract_rank

    def extract_items
      each_item do |item|
        items << Item.new(
          rank: rank, title: title(item), uri: url(item),
          summary: summary(item), host: host(item)
        )
        break if items.count >= count
      end
    end

    def search
      @page, @items = nil, []

      init_progress

      search_loop do
        send_request
        break if @page.nil?
        @totalcount = extract_total if totalcount.nil?
        extract_items
        update_progress
      end
    end

    def init_progress
      @pb = ProgressBar.create(
        format: '%t |%b>>%i| %p%%',
        title: @keyword,
        total: count
      ) if @progress
    end

    def update_progress
      @pb.progress = items.count if @progress
    end

    def search_loop
      while items.count < count
        len = items.count
        yield
        break if items.count == len
      end
    end

    def not_found(code, uri)
      fail NotFound, "#{code} page not found #{uri}"
    end

    def server_error(code, uri)
      if @retry_level > -1
        sleep 30
        get_page
      else
        fail ServerError, "#{code} server error #{uri}"
      end
    end

    def access_block(code, uri)
      fail AccessBlock, "#{code} access blocked #{uri}"
    end
  end
end
