class TestRackApp
  def self.call(env)
    [200, {}, 'Hello World']
  end
end
