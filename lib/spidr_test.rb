require 'spidr'

class SpidrTest
  autoload :Server, 'spidr_test/server'
  autoload :Capturer, 'spidr_test/capturer'

  NOOP = Proc.new{}

  attr_accessor :app, :spidr, :path

  def self.crawl(&block)
    spidr_test = SpidrTest.new(&block)
    spidr_test.crawl!
  end

  def initialize
    @spidr = Capturer.new
    @path = '/'
    @success_handler = NOOP
    @failure_handler = ->(page){ raise "Failure on #{page.url.path}: #{page.body}" }
    @error_handler = ->(url) { raise "Cannot connect to #{url.path}" }

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
