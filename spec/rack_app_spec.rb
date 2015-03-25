require 'spec_helper'
require 'spidr_test'

RSpec.describe SpidrTest do
  context 'rack app' do
    it 'invokes test app' do
      expect(TestRackApp).to receive(:call)

      SpidrTest.crawl(self) do |spidr|
        spidr.app = TestRackApp
      end
    end
  end
end
