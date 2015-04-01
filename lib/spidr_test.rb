require 'spidr'

class SpidrTest
  autoload :Server, 'spidr_test/server'
  autoload :Capturer, 'spidr_test/capturer'

  attr_accessor :app, :spidr, :path, :context,
                :test_define, :success_handler, :failure_handler, :error_handler

  DEFAULTS = {
    path: '/'.freeze,
    success_handler: ->(url, page) { },
    failure_handler: ->(url, page) { raise "Failure on #{url.path}: #{page.body}" },
    error_handler: ->(url, page) { raise "Cannot connect to #{url.path}" },
    test_define: ->(url, &block) { block.call },
  }.freeze

  def self.crawl(options = {}, &block)
    spidr_test = SpidrTest.new(options, &block)
    spidr_test.crawl!
  end

  def initialize(options)
    @spidr = Capturer.new

    collated_options = DEFAULTS.dup.merge!(options)
    collated_options.each do |key, val|
      self.public_send("#{key}=", val)
    end

    yield self if block_given?
  end

  def crawl!
    capturer = self.spidr
    Server.run(app) do |server|
      Spidr.site(server.url + path) do |spidr|
        capturer._invoke(spidr)

        spidr.every_failed_url(&method(:failed_url))
        spidr.every_page(&method(:check_page))
      end
    end
  end

  def success?(page)
    page.code < 500
  end

  def context=(context)
    @context = context
    @test_define = ->(url, &block) do
      context.specify(url.path, &block)
    end
  end

  private

  def failed_url(url)
    error_handler = @error_handler
    @test_define.call(url) do
      @error_handler.call(url, nil)
    end
  end

  def check_page(page)
    test = self
    @test_define.call(page.url) do
      if test.success?(page)
        test.success_handler.call(page.url, page)
      else
        test.failure_handler.call(page.url, page)
      end
    end
  end
end
