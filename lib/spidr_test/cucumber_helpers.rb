require 'spidr_test'

module SpidrTest
  module CucumberHelpers
    def spidr_test_options(additional_options = {})
      @spidr_test_options ||= {}
      @spidr_test_options.merge!(additional_options)
    end
  end
end

Given 'SpidrTest is crawling "$app" starting at "$path"' do |app_name, path|
  spidr_test_options(app: eval(app_name), path: path)
end

Then 'SpidrTest crawls' do
  SpidrTest.crawl(spidr_test_options(context: self))
end
