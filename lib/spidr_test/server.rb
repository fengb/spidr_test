require 'rack'
require 'webrick/log'

class SpidrTest
  class Server
    NULL_LOGGER = WEBrick::Log.new(File::NULL)

    def self.servers
      @servers ||= {}
    end

    def self.start(app)
      if servers[app]
        $stderr.puts "Already started server for #{app}"
        return servers[app]
      end

      servers[app] = self.new(app)
      servers[app].start!
    end

    def self.stop(app)
      server = servers[app]
      if server.nil?
        $stderr.puts "Did not locate server for #{app}"
        return
      end

      server.stop!
      servers.delete(app)
    end

    def self.run(app)
      if self.servers[app]
        yield self.servers[app]
      else
        server = self.new(app)
        server.start!
        yield server
        server.stop!
      end
    end

    def initialize(app)
      @app = app
    end

    def url
      if @thread && @thread[:port]
        "http://localhost:#{@thread[:port]}"
      else
        nil
      end
    end

    def start!
      mutex = Mutex.new
      server_ready = ConditionVariable.new
      @thread = Thread.new do
        Rack::Handler::WEBrick.run(@app, Port: 0, Logger: NULL_LOGGER, AccessLog: []) do |server|
          Thread.current[:port] = server.config[:Port]
          mutex.synchronize { server_ready.signal }
        end
      end
      @thread.abort_on_exception = true
      mutex.synchronize { server_ready.wait(mutex) }
    end

    def stop!
      @thread.kill
      @thread.join
    end
  end
end
