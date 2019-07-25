require "./filesystem"

module Explorer::Web
  class Api
    def initialize(@explorer_bind_host : String, @explorer_bind_port : Int32, @log = Explorer::Logger.new(STDOUT))
    end

    # TODO(fenicks): Generate Mint files
    def web_routes
      get "/" do |context, _params|
        content_type_html(context)
        context.response.print File.read("./src/explorer/web/static/dist/index.html")
        context
      end
    end

    # API example:  https://developers.eos.io/keosd/v1.3.0/reference#sign_transaction
    def api_routes_v1
      prefix = "/api/v1"

      # /blocks
      ["#{prefix}/blocks", "#{prefix}/blocks/limit/:limit"].each do |route|
        get route do |context, params|
          content_type_json(context)
          limit = -1
          limit = params["limit"].to_i32 if params["limit"]?
          context.response.print R.blocks(limit)
          context
        end
      end

      # /transactions
      ["#{prefix}/transactions", "#{prefix}/transactions/limit/:limit"].each do |route|
        get route do |context, params|
          content_type_json(context)
          limit = -1
          limit = params["limit"].to_i32 if params["limit"]?
          context.response.print R.transactions(limit)
          context
        end
      end
    end

    def run
      # Generate virtual filesystem routes from "public" folder
      Filesystem.files.each do |file|
        get file.path do |context, _params|
          Filesystem.serve(file, context)
        end
      end
      api_routes_v1
      web_routes

      handlers = [
        HTTP::LogHandler.new(STDOUT),
        HTTP::ErrorHandler.new,
        route_handler,
      ]

      server = HTTP::Server.new(handlers)
      server.bind_tcp(@explorer_bind_host, @explorer_bind_port)
      @log.info "Starting the webapp at: #{@explorer_bind_host}:#{@explorer_bind_port}"
      server.listen
    end

    private def content_type(context : HTTP::Server::Context, type : Symbol = :plain)
      context.response.content_type = case type
                                      when :json
                                        "application/json"
                                      when :html
                                        "text/html"
                                      when :plain
                                        "text/plain"
                                      else
                                        "text/plain"
                                      end
    end

    private def content_type_plain(context)
      content_type(context, :plain)
    end

    private def content_type_html(context)
      content_type(context, :html)
    end

    private def content_type_json(context)
      content_type(context, :json)
    end

    include ::Router
  end
end
