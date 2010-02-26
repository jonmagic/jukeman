#!/usr/bin/env ruby
require 'rubygems'
require 'mongo'
require 'benchmark'
require 'socket'
require 'digest/md5'
require 'thread'

include Mongo

c  = Mongo::Connection.new('localhost', 27017, :pool_size => 10)
coll = c['perf']['docs']
coll.remove

doc = {'name' => 'kyle', 
       'languages' => ['ruby', 'javascript', 'c'],
       'date'      => Time.now}

TRIES = 5000
@threads = []
100.times do |n|
  @threads << Thread.new do
    50.times do |n|
    doc['n'] = n*n
    coll.insert(doc)
    doc.delete(:_id)
    end
  end
end
@threads.join
