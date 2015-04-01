require 'minitest_helper'
require 'spidr_test'

class TestSpidrTest < Minitest::Test
  def test_root
    SpidrTest.crawl app: TestRackApp,
                    context: self
  end
end
