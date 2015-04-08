require 'minitest_helper'
require 'spidr_test'

class TestSpidrTest < Minitest::Test
  def test_root
    SpidrTest.crawl app: TestRackApp,
                    context: self
  end

  def test_with_500
    SpidrTest.crawl app: TestRackApp,
                    path: '/with-500',
                    context: self,
                    expected_fail_paths: ['/status/500']
  end

  def test_example_com
    SpidrTest.crawl url: 'http://example.com',
                    context: self
  end
end
