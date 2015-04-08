module SpidrTest
  autoload :Capturer, 'spidr_test/capturer'
  autoload :Handlers, 'spidr_test/handlers'
  autoload :Runner,   'spidr_test/runner'
  autoload :Server,   'spidr_test/server'
  autoload :Version,  'spidr_test/version'

  def self.crawl(options = {}, &block)
    runner = SpidrTest::Runner.new(options, &block)
    runner.crawl!
  end
end
