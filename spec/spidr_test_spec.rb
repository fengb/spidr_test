require 'spec_helper'
require 'spidr_test'

RSpec.describe SpidrTest do
  before(:all) { SpidrTest::Server.start(TestRackApp) }
  after(:all) { SpidrTest::Server.stop(TestRackApp) }

  it 'hits all routes' do
    routes = []

    SpidrTest.crawl do |test|
      test.app = TestRackApp
      test.spidr.every_page do |page|
        routes << page.url.path
      end
    end

    expect(routes).to contain_exactly('/', '/status/200', '/status/404')
  end

  it 'generates the bodies' do
    bodies = {}

    SpidrTest.crawl do |test|
      test.app = TestRackApp
      test.spidr.every_page do |page|
        bodies[page.url.path] = page.body
      end
    end

    expect(bodies).to include('/status/200' => '200', '/status/404' => '404')
  end

  it 'detects status codes' do
    codes = {}

    SpidrTest.crawl do |test|
      test.app = TestRackApp
      test.spidr.every_page do |page|
        codes[page.url.path] = page.code
      end
    end

    expect(codes).to include('/status/200' => 200, '/status/404' => 404)
  end

  it 'handles successes and failures' do
    successes = []
    failures = []

    SpidrTest.crawl(
      app: TestRackApp,
      path: '/with-500',
      success_handler: ->(options) { successes << options[:url].path },
      failure_handler: ->(options) { failures << options[:url].path },
    )

    expect(successes).to include('/status/200', '/status/404')
    expect(failures).to include('/status/500')
  end
end
