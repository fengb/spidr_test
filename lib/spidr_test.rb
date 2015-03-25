require 'spidr'

class SpidrTest
  autoload :Server, 'spidr_test/server'

  def self.crawl(&block)
    spidr_test = SpidrTest.new(&block)
    spidr_test.crawl!
  end

  attr_accessor :app

  def initialize
    if block_given?
      yield self
    end
  end

  def crawl!
    Server.run(app) do |server|
      Spidr.site(server.url)
    end
  end
end
