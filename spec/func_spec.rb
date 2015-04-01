require 'spec_helper'
require 'spidr_test'

RSpec.describe SpidrTest, 'func' do
  context TestRackApp do
    context 'default' do
      SpidrTest.crawl app: TestRackApp,
                      context: self
    end

    context '/with-500' do
      SpidrTest.crawl app: TestRackApp,
                      path: '/with-500',
                      context: self,
                      failure_handler: ->(url, page) do
                        pending { SpidrTest::DEFAULT[:test_handler].call(url, page) }
                      end
    end
  end

  context 'http://example.com' do
    SpidrTest.crawl url: 'http://example.com',
                    context: self
  end
end
