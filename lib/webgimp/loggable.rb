module Webgimp
  module Loggable
    def logger
      Loggable.logger
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end