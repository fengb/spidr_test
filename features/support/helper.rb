require 'spidr_test/cucumber_helpers'

spec_helper = File.expand_path('../../../spec/spec_helper', __FILE__)
require spec_helper

World(SpidrTest::CucumberHelpers)
