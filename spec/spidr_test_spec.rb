require 'spec_helper'
require 'spidr_test'

RSpec.describe SpidrTest do
  it 'invokes test app' do
    expect(TestRackApp).to receive(:call)

    SpidrTest.crawl do |test|
      test.app = TestRackApp
    end
  end

  it 'hits all routes' do
    crawled = []

    SpidrTest.crawl do |test|
      test.app = TestRackApp
      test.spidr.every_page do |page|
        crawled << page.url.path
      end
    end

    expect(crawled).to contain_exactly('/', '/foo', '/bar')
  end

  it 'generates the bodies' do
    pages = {}

    SpidrTest.crawl do |test|
      test.app = TestRackApp
      test.spidr.every_page do |page|
        pages[page.url.path] = page.body
      end
    end

    expect(pages).to include('/foo' => 'Foo', '/bar' => 'Bar')
  end

  it 'generates the bodies' do
    bodies = {}

    SpidrTest.crawl do |test|
      test.app = TestRackApp
      test.spidr.every_page do |page|
        bodies[page.url.path] = page.body
      end
    end

    expect(bodies).to include('/foo' => 'Foo', '/bar' => 'Bar')
  end

  it 'detects status codes' do
    codes = {}

    SpidrTest.crawl do |test|
      test.app = TestRackApp
      test.path = '/status/common'
      test.spidr.every_page do |page|
        codes[page.url.path] = page.code
      end
    end

    expect(codes).to include('/status/200' => 200, '/status/404' => 404, '/status/500' => 500)
  end
end
