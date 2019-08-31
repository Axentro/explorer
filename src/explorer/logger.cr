module Explorer
  class Logger < ::Logger
    STDOUT.sync = true

    def log(severity, message, progname = nil)
      return if severity < level || !@io
      msg = case severity
            when Severity::DEBUG
              message.colorize.fore(:light_gray).to_s
            when Severity::INFO
              message.colorize.fore(:light_green).to_s
            when Severity::WARN
              message.colorize.fore(:yellow).to_s
            when Severity::ERROR, Severity::FATAL, Severity::UNKNOWN
              message.colorize.fore(:red).to_s
            else
              message
            end
      write(severity, Time.now, progname || @progname, msg)
    end

    def self.instance : Explorer::Logger
      @@logger ||= new(STDOUT)
      @@logger.not_nil!.level = ::Logger::DEBUG if ENV["DEBUG"]?
      @@logger.not_nil!
    end
  end
end
