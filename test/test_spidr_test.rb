require 'minitest_helper'
require 'spidr_test'

class TestSpidrTest < Minitest::Test
  def test_root
    SpidrTest.crawl app: TestRackApp,
                    context: self
  end

=begin
  def test_with_500
    SpidrTest.crawl app: TestRackApp,
                    path: '/with-500',
                    context: self
  end
=end

  def test_example_com
    SpidrTest.crawl url: 'http://example.com',
                    context: self
  end
end
