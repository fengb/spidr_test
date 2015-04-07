class SpyHandler
  attr_reader :success_calls, :failure_calls, :error_calls

  def initialize
    @success_calls = []
    @failure_calls = []
    @error_calls = []
  end

  def success(options)
    @success_calls << options
  end

  def failure(options)
    @failure_calls << options
  end

  def error(options)
    @error_calls << options
  end
end
