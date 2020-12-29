require "./filesystem"

module Explorer::Web
  class Api
    include Explorer::Logger

    def initialize(@explorer_bind_host : String, @explorer_bind_port : Int32)
    end

    # Default routes, @see("web/static/source/Routes.mint")
    def web_routes
      get "/" do |context, _|
        content_type_html(context)
        context.response.print Filesystem.get?("index.html").try(&.gets_to_end)
        context
      end
    end

    # API example:  https://developers.eos.io/manuals/eos/latest/nodeos/plugins/producer_api_plugin/api-reference/index
    def api_routes_v1
      prefix = "/api/v1"

      # /addresses
      ["#{prefix}/addresses",
       "#{prefix}/addresses/page/:page/length/:length"].each do |route|
        get route do |context, params|
          content_type_json(context)
          if params.["page"]? && params["length"]? # /addresses/page/:page/length/:length
            page = begin params["page"].to_i32 rescue 0 end
            length = begin params["length"].to_i32 rescue 0 end
            log.debug("#{prefix}/addresses/page/:page/length/:length ==> #{page} - #{length}")
            context.response.print R.addresses(page, length)
          else                                 # /addresses
            context.response.print R.addresses # All tokens
          end
          context
        end
      end

      # /address
      get "#{prefix}/address/:name" do |context, params|
        content_type_json(context)
        context.response.print R.address(params["name"])
        context
      end

      get "#{prefix}/addresses/pageCount" do |context, _|
        content_type_json(context)
        context.response.print R.addresses_page_count
        context
      end

      # /blocks
      get "#{prefix}/blocks" do |context, _|
        content_type_json(context)
        context.response.print R.blocks # All blocks
        context
      end

      # TODO(fenicks): add slow and fast parameter
      # get "#{prefix}/blocks/count" do |context, _|
      #   content_type_json(context)
      #   context.response.print R.blocks_count
      #   context
      # end

      get "#{prefix}/blocks/pageCount" do |context, _|
        content_type_json(context)
        context.response.print R.blocks_page_count
        context
      end

      get "#{prefix}/blocks/top/:top" do |context, params|
        content_type_json(context)
        top = begin params["top"].to_i32 rescue 1 end
        context.response.print R.blocks(top)
        context
      end

      get "#{prefix}/blocks/page/:page/length/:length" do |context, params|
        content_type_json(context)
        page = begin params["page"].to_i32 rescue 0 end
        length = begin params["length"].to_i32 rescue 0 end
        context.response.print R.blocks(page, length)
        context
      end

      # /block
      get "#{prefix}/block/:index" do |context, params|
        content_type_json(context)
        index = begin
          params["index"].to_i32
        rescue
          -1
        end
        context.response.print R.block(index)
        context
      end

      # /domains
      ["#{prefix}/domains",
       "#{prefix}/domains/page/:page/length/:length"].each do |route|
        get route do |context, params|
          content_type_json(context)
          if params.["page"]? && params["length"]? # /domains/page/:page/length/:length
            page = begin params["page"].to_i32 rescue 0 end
            length = begin params["length"].to_i32 rescue 0 end
            log.debug("#{prefix}/domains/page/:page/length/:length ==> #{page} - #{length}")
            context.response.print R.domains(page, length)
          else                               # /domains
            context.response.print R.domains # All domains
          end
          context
        end
      end

      get "#{prefix}/domains/pageCount" do |context, _|
        content_type_json(context)
        context.response.print R.domains_page_count
        context
      end

      # /domain
      get "#{prefix}/domain/:name" do |context, params|
        content_type_json(context)
        context.response.print R.domain(params["name"])
        context
      end

      # /search
      post "#{prefix}/search/:p" do |context, params|
        content_type_json(context)

        chan = Channel(Hash(String, JSON::Any)).new(5)
        spawn { chan.send({"addresses" => JSON.parse(R.address(params["p"]))}) }
        spawn { chan.send({"blocks" => JSON.parse(R.block(begin params["p"].to_i32 rescue -1 end))}) }
        spawn { chan.send({"domains" => JSON.parse(R.domain(params["p"]))}) }
        spawn { chan.send({"tokens" => JSON.parse(R.token(params["p"]))}) }
        spawn { chan.send({"transactions" => JSON.parse(R.transaction(params["p"]))}) }

        data = Hash(String, JSON::Any).new
        5.times { data = data.merge(chan.receive) }

        # Remove entries with empty values
        data.delete_if { |k, v| v.size == 0 }
        result = {
          "results":    data.size,
          "controller": data.first_key?,
        }
        context.response.print result.to_json
        context
      end

      # /tokens
      ["#{prefix}/tokens",
       "#{prefix}/tokens/page/:page/length/:length"].each do |route|
        get route do |context, params|
          content_type_json(context)
          if params.["page"]? && params["length"]? # /tokens/page/:page/length/:length
            page = begin params["page"].to_i32 rescue 0 end
            length = begin params["length"].to_i32 rescue 0 end
            log.debug("#{prefix}/tokens/page/:page/length/:length ==> #{page} - #{length}")
            context.response.print R.tokens(page, length)
          else                              # /tokens
            context.response.print R.tokens # All tokens
          end
          context
        end
      end

      get "#{prefix}/tokens/pageCount" do |context, _|
        content_type_json(context)
        context.response.print R.tokens_page_count
        context
      end

      # /token
      get "#{prefix}/token/:name" do |context, params|
        content_type_json(context)
        context.response.print R.token(params["name"])
        context
      end

      # /transactions
      ["#{prefix}/transactions",
       "#{prefix}/transactions/top/:top",
       "#{prefix}/transactions/page/:page/length/:length"].each do |route|
        get route do |context, params|
          content_type_json(context)
          if params["top"]? # /transactions/top/:top
            top = begin params["top"].to_i32 rescue 1 end
            log.debug("#{prefix}/transactions/top/:top ==> #{top}")
            context.response.print R.transactions(top)
          elsif params["page"]? && params["length"]? # /transactions/page/:page/length/:length
            page = begin params["page"].to_i32 rescue 0 end
            length = begin params["length"].to_i32 rescue 0 end
            log.debug("#{prefix}/transactions/page/:page/length/:length ==> #{page} - #{length}")
            context.response.print R.transactions(page, length)
          else                                    # /transactions
            context.response.print R.transactions # All transactions
          end
          context
        end
      end

      get "#{prefix}/transactions/pageCount" do |context, _|
        content_type_json(context)
        context.response.print R.transactions_page_count
        context
      end

      # /transaction
      get "#{prefix}/transaction/:txid" do |context, params|
        content_type_json(context)
        context.response.print R.transaction(params["txid"])
        context
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
        Explorer::Web::LogHandler.new,
        route_handler,
        Explorer::Web::ErrorHandler.new,
      ]

      server = HTTP::Server.new(handlers)
      server.bind_tcp(@explorer_bind_host, @explorer_bind_port)
      log.info "Starting the webapp at: #{@explorer_bind_host}:#{@explorer_bind_port}"
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

  class ErrorHandler
    include HTTP::Handler

    def call(context : HTTP::Server::Context)
      context.response.reset
      context.response.content_type = "text/html"
      context.response.status = :ok
      context.response.print Filesystem.get?("index.html").try(&.gets_to_end)
    end
  end

  class LogHandler
    include HTTP::Handler
    include Explorer::Logger

    def call(context)
      start = Time.monotonic

      begin
        call_next(context)
      ensure
        elapsed = Time.monotonic - start
        elapsed_text = elapsed_text(elapsed)

        req = context.request
        res = context.response

        addr =
          {% begin %}
          case remote_address = req.remote_address
          when nil
            "-"
          {% unless flag?(:win32) %}
          when Socket::IPAddress
            remote_address.address
          {% end %}
          else
            remote_address
          end
          {% end %}

        log.info "[http-log] #{addr} - #{req.method} #{req.resource} #{req.version} - #{res.status_code} (#{elapsed_text})"
      end
    end

    private def elapsed_text(elapsed)
      minutes = elapsed.total_minutes
      return "#{minutes.round(2)}m" if minutes >= 1

      "#{elapsed.total_seconds.humanize(precision: 2, significant: false)}s"
    end
  end
end
