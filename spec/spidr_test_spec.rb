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

  it 'generates the bodies' do
    pages = {}
    subject.spidr.every_page do |page|
      pages[page.url.path] = page.body
    end
    subject.crawl!

    expect(pages).to include('/foo' => 'Foo', '/bar' => 'Bar')
  end

  it 'generates the bodies' do
    bodies = {}
    subject.spidr.every_page do |page|
      bodies[page.url.path] = page.body
    end
    subject.crawl!

    expect(bodies).to include('/foo' => 'Foo', '/bar' => 'Bar')
  end

  it 'detects status codes' do
    codes = {}
    subject.path = '/status/common'
    subject.spidr.every_page do |page|
      codes[page.url.path] = page.code
    end
    subject.crawl!

    expect(codes).to include('/status/200' => 200, '/status/404' => 404, '/status/500' => 500)
  end
end
