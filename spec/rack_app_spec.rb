require 'spec_helper'
require 'spidr_test'

RSpec.describe SpidrTest do
  subject do
    SpidrTest.new do |test|
      test.app = TestRackApp
    end
  end

  it 'invokes test app' do
    expect(TestRackApp).to receive(:call)
    subject.crawl!
  end

  it 'hits all routes' do
    crawled = []
    subject.spidr.every_page do |page|
      crawled << page.url.path
    end
    subject.crawl!

    expect(crawled).to contain_exactly('/', '/foo', '/bar')
  end
end
