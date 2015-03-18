
module Serps
  # Serps Item Class
  class Item
    attr_reader :rank
    attr_reader :title
    attr_reader :uri
    attr_reader :summary
    attr_reader :host
    attr_reader :note

    def initialize(params)
      @rank = params[:rank]
      @title = params[:title]
      @uri = params[:uri]
      @summary = params[:summary]
      @host = params[:host]
      @note = params[:note]
    end
  end
end
