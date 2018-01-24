$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bitcoin'
RSpec.configure do |c|
      c.include Bitcoin
end
