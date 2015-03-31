require 'spidr'

class SpidrTest
  autoload :Server, 'spidr_test/server'
  autoload :Capturer, 'spidr_test/capturer'

  SUCCESS_HANDLER = ->(page){}
  FAILURE_HANDLER = ->(page){ raise "Failure on #{page.url.path}: #{page.body}" }
  ERROR_HANDLER = ->(url) { raise "Cannot connect to #{url.path}" }

  attr_accessor :app, :spidr, :path

  def self.crawl(options = {}, &block)
    spidr_test = SpidrTest.new(options, &block)
    spidr_test.crawl!
  end

  def initialize(options)
    @spidr = Capturer.new
    @path = '/'
    @success_handler = SUCCESS_HANDLER
    @failure_handler = FAILURE_HANDLER
    @error_handler = ERROR_HANDLER

    options.each do |key, val|
      self.send("#{key}=", val)
    end

    yield self if block_given?
  end

  def crawl!
    capturer = self.spidr
    Server.run(app) do |server|
      Spidr.site(server.url + path) do |spidr|
        capturer._invoke(spidr)

        spidr.every_failed_url(&@error_handler)
        spidr.every_page do |page|
          if page.code < 500
            @success_handler.call(page)
          else
            @failure_handler.call(page)
          end
        end
      end
    end
  end

  def context=(context)
    @context = context
    success do |page|
      context.specify(page.url.path) { SUCCESS_HANDLER.call(page) }
    end

    failure do |page|
      context.specify(page.url.path) { FAILURE_HANDLER.call(page) }
    end

    error do |url|
      context.specify(page.url.path) { ERROR_HANDLER.call(page) }
    end
  end

  def success(&block)
    @success_handler = block
  end

  def failure(&block)
    @failure_handler = block
  end

  def error(&block)
    @error_handler = block
  end
end
