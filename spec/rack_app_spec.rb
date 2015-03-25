require 'spec_helper'
require 'spidr_test'

RSpec.describe SpidrTest do
  context 'rack app' do
    subject do
      SpidrTest.new do |test|
        test.app = TestRackApp
      end
    end

    it 'invokes test app' do
      expect(TestRackApp).to receive(:call)
      subject.crawl!
    end
  end
end
