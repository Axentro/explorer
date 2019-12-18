module Explorer::Web
  class Filesystem
    extend BakedFileSystem

    bake_folder "./static/dist"

    def self.serve(file, context)
      req = context.request
      resp = context.response
      resp.status_code = 200
      resp.content_type = file.mime_type
      if req.headers["Accept-Encoding"]? =~ /gzip/
        resp.headers["Content-Encoding"] = "gzip"
        resp.content_length = file.compressed_size
        file.write_to_io(resp, compressed: true)
      else
        resp.content_length = file.size
        file.write_to_io(resp, compressed: false)
      end
      context
    end
  end
end
