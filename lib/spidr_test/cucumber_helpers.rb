require 'spidr_test'

module SpidrTest
  module CucumberHelpers
    def spidr_test
      @spidr_test ||= SpidrTest::Runner.new(context: self)
    end
  end
end

Given 'SpidrTest is crawling "$app" starting at "$path"' do |app_name, path|
  spidr_test.app = eval(app_name)
  spidr_test.path = path
end

Then 'SpidrTest crawls' do
  spidr_test.crawl!
end
