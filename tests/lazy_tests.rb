#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require_relative './fake_responses'

class FooBarUser < LazyScraper::Entity
  attr_hook 'http://foo.bar/user/:id',
    :name, :shortbio, :counts do |doc, attrs|

    attrs[:name] = doc.css('h2').text.sub(/'s profile$/, '')
    attrs[:shortbio] = doc.css('h2 + p').text
    
    counts = doc.css('counts span')
    
    attrs[:counts] = {
      :favorites => counts[0].to_i,
      :reviews   => counts[1].to_i,
      :friends   => counts[2].to_i
    }
  end

  attr_hook 'http://foo.bar/user/:id/bio',
    :bio do |doc, attrs|
    attrs[:bio] = doc.css('p').map(&:text).join("\n")
  end
end

class LazyScraper_test < Test::Unit::TestCase
end
