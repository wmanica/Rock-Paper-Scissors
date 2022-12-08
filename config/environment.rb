# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# logging configuration
Rails.application.configure do
  Rails.logger = Logger.new(STDERR)
  config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")
  config.logger.datetime_format = "%Y-%m-%d %H:%M:%S"
  config.logger.formatter = proc do | severity, time, progname, msg |
    "#{time}, #{severity}: #{msg} from #{progname} \n"
  end
  config.log_tags = [:request_id]
end
