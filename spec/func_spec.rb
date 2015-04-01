require 'spec_helper'
require 'spidr_test'

RSpec.describe SpidrTest, 'func' do
  context TestRackApp do
    specify '/' do
      SpidrTest.crawl app: TestRackApp,
                      context: self
    end

=begin
    specify '/with-500' do
      SpidrTest.crawl app: TestRackApp,
                      path: '/with-500',
                      context: self
    end
=end
  end

  specify 'http://example.com' do
    SpidrTest.crawl url: 'http://example.com',
                    context: self
  end
end
