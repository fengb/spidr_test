require 'spidr'

module SpidrTest
  class Runner
    attr_accessor :app, :path, :url, :context, :spidr, :handler,
                  :expected_fail_paths,
                  :success_message, :failure_message, :error_message

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

      collated_options = DEFAULT.merge(options)
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

    def expected_failure?(page)
      expected_fail_paths && expected_fail_paths.include?(page.url.path)
    end

    def message(page)
      if success?(page)
        success_message.call(page.url, page)
      else
        failure_message.call(page.url, page)
      end
    end

    def context=(context)
      @context = context
      @handler = Handlers.for(context)
    end

    private

    def crawl_url!(url)
      capturer = self.spidr
      Spidr.site(url) do |spidr|
        capturer._invoke(spidr)

        spidr.every_failed_url(&method(:failed_url))
        spidr.every_page(&method(:check_page))
      end
    end

    def failed_url(url)
      handler.error(
        url: url,
        path: url.path,
        page: nil,
        message: error_message.call(url, nil),
      )
    end

    def check_page(page)
      options = {
        url: page.url,
        path: page.url.path,
        page: page,
        message: message(page),
      }

      if success?(page) ^ expected_failure?(page)
        handler.success(options)
      else
        handler.failure(options)
      end
    end
  end
end
