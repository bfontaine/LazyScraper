#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require 'test/unit'
require 'simplecov'
require_relative './fake_responses'

test_dir = File.expand_path( File.dirname(__FILE__) )

SimpleCov.start { add_filter '/tests/' } if ENV['COVERAGE']

require_relative '../lib/lazyscraper.rb'

for t in Dir.glob( File.join( test_dir,  '*_tests.rb' ) )
  require t
end

class LazyScraperTests < Test::Unit::TestCase

  # == LazyScraper#version == #

  def test_lazyscraper_version
    assert(LazyScraper.version =~ /^\d+\.\d+\.\d+/)
  end

end


exit Test::Unit::AutoRunner.run
