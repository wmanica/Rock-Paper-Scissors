module RpsLogger
  def log_error(message)
    Rails.logger.error(message)
  end
end
