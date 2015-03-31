require 'spec_helper'
require 'spidr_test'

RSpec.describe SpidrTest, 'func' do
  SpidrTest.crawl(app: TestRackApp, context: self, path: '/')
end
