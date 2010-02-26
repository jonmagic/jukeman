require 'rubygems'
require 'mongo'
require 'benchmark'

TRIALS = 500000

include Mongo

Benchmark.bm do |x|

  x.report('original') do
    TRIALS.times do
      ObjectID.new(nil, true)
    end
  end

  x.report('new') do
    TRIALS.times do
      ObjectID.new(nil, false)
    end
  end

end
