require 'spidr'

class SpidrTest
  autoload :Server, 'spidr_test/server'
  autoload :Capturer, 'spidr_test/capturer'

  attr_accessor :app, :spidr, :path

  def self.crawl(&block)
    spidr_test = SpidrTest.new(&block)
    spidr_test.crawl!
  end

  def initialize
    @spidr = Capturer.new
    @path = '/'

    if block_given?
      yield self
    end
  end

  def crawl!
    capturer = self.spidr
    Server.run(app) do |server|
      Spidr.site(server.url + path) do |spidr|
        capturer._invoke(spidr)

        spidr.every_failed_url do |url|
          raise "Cannot connect to #{url}"
        end
      end
    end
  end
end
