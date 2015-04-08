Feature: SpidrTest
  Scenario: crawling a Rack app
      Given SpidrTest is crawling "TestRackApp" starting at "/"
       Then SpidrTest crawls
