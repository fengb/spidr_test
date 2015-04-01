require 'spidr'

class SpidrTest
  autoload :Server, 'spidr_test/server'
  autoload :Capturer, 'spidr_test/capturer'
  autoload :ContextHandlers, 'spidr_test/context_handlers'

  attr_accessor :app, :path, :url, :spidr, :context,
                :success_handler, :failure_handler, :error_handler

  DEFAULT = {
    path: '/'.freeze,
    success_handler: ->(url, page) { },
    failure_handler: ->(url, page) { raise "Failure on #{url}: #{page.body}" },
    error_handler: ->(url, page) { raise "Cannot connect to #{url}" },
  }.freeze

  def self.crawl(options = {}, &block)
    spidr_test = SpidrTest.new(options, &block)
    spidr_test.crawl!
  end

  def initialize(options)
    @spidr = Capturer.new

    collated_options = DEFAULT.dup.merge!(options)
    collated_options.each do |key, val|
      self.public_send("#{key}=", val)
    end

    yield self if block_given?
  end

  def crawl!
    if @url
      crawl_url!(@url)
    else
      Server.run(app) do |server|
        crawl_url!(server.url + path)
      end
    end
  end

  def success?(page)
    page.code < 500
  end

  def context=(context)
    @context = context

    handler = ContextHandlers.for(context)
    if handler
      apply handler
    else
      $stderr.puts "SpidrTest: context not understood. Using default handlers."
    end
  end

  private

  def apply(handler)
    @success_handler = handler.method(:success)
    @failure_handler = handler.method(:failure)
    @error_handler = handler.method(:error)
  end

  def crawl_url!(url)
    capturer = self.spidr
    Spidr.site(url) do |spidr|
      capturer._invoke(spidr)

      spidr.every_failed_url(&method(:failed_url))
      spidr.every_page(&method(:check_page))
    end
  end

  def failed_url(url)
    context.instance_exec(url, nil, &error_handler)
  end

  def check_page(page)
    if success?(page)
      context.instance_exec(page.url, page, &success_handler)
    else
      context.instance_exec(page.url, page, &failure_handler)
    end
  end
end
