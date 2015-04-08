module SpidrTest
  module CucumberHelpers
  end
end

Given 'SpidrTest is crawling "$app" starting at "$path"' do |app_name, path|
  @spidr_test_options ||= {}
  @spidr_test_options[:app] = eval(app_name)
  @spidr_test_options[:path] = path
end

Then 'SpidrTest crawls' do
  @spidr_test_options ||= {}
  @spidr_test_options[:context] = self
  SpidrTest.crawl(@spidr_test_options)
end
