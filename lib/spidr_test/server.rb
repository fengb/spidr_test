require 'rack'

class SpidrTest
  class Server
    def self.run(app)
      server = self.new(app)
      server.start!
      yield server
      server.stop!
    end

    def initialize(app)
      @app = app
      @port = 43198
    end

    def url
      "http://localhost:#{@port}"
    end

    def start!
      mutex = Mutex.new
      server_ready = ConditionVariable.new
      @thread = Thread.new do
        Rack::Handler::WEBrick.run(@app, Port: @port, Logger: null_logger, AccessLog: []) do
          mutex.synchronize { server_ready.signal }
        end
      end
      @thread.abort_on_exception = true
      mutex.synchronize { server_ready.wait(mutex) }
    end

    def null_logger
      @null_logger ||= WEBrick::Log.new(File::NULL)
    end

    def stop!
      @thread.kill
    end
  end
end
