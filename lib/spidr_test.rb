require 'spidr'

class SpidrTest
  autoload :Server, 'spidr_test/server'
  autoload :Capturer, 'spidr_test/capturer'
  autoload :ContextHandlers, 'spidr_test/context_handlers'

  attr_accessor :app, :path, :url, :context, :spidr,
                :success_message, :failure_message, :error_message,
                :success_handler, :failure_handler, :error_handler

  DEFAULT = {
    path: '/'.freeze,
    context: nil,
    success_message: ->(url, page){ url.path },
    failure_message: ->(url, page){ "Failure on #{url.path}: #{page.body}" },
    error_message:   ->(url, page){ "Cannot connect to #{url}" },
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
    apply ContextHandlers.for(context)
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
    options = {
      url: url,
      page: nil,
      message: error_message.call(url, nil),
    }
    context.instance_exec(options, &error_handler)
  end

  def check_page(page)
    if success?(page)
      options = {
        url: page.url,
        page: page,
        message: success_message.call(page.url, page),
      }
      context.instance_exec(options, &success_handler)
    else
      options = {
        url: page.url,
        page: page,
        message: failure_message.call(page.url, page),
      }
      context.instance_exec(options, &failure_handler)
    end
  end
end
