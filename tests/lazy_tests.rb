#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require_relative './fake_responses'

class FooBarUser < LazyScraper::Entity
  attr_hook 'http://foo.bar/user/:id',
    :name, :shortbio, :counts do |doc, attrs|

    attrs[:name] = doc.css('h2').text.sub(/'s profile$/, '')
    attrs[:shortbio] = doc.css('h2 + p').text
    
    counts = doc.css('.counts span')
    
    attrs[:counts] = {
      :favorites => counts[0].text.to_i,
      :reviews   => counts[1].text.to_i,
      :friends   => counts[2].text.to_i
    }
  end

  attr_hook 'http://foo.bar/user/:id/bio',
    :bio do |doc, attrs|
    attrs[:bio] = doc.css('p').map(&:text).join("\n")
  end
end

class LazyScraper_test < Test::Unit::TestCase
  def setup
    FakeWeb.last_request = nil
    FooBarUser.reset_hooks
  end

  def test_lazy_entity_creation
    f = FooBarUser.new :id => 42
    assert_nil(FakeWeb.last_request)
  end

  def test_entity_fetch_attr
    f = FooBarUser.new :id => 42
    assert_nil(FakeWeb.last_request)
    assert_equal('John Doe', f.name)
    assert_not_nil(FakeWeb.last_request)
  end

  def test_entity_doesnt_re_fetch_attr
    f = FooBarUser.new :id => 42
    assert_nil(FakeWeb.last_request)
    assert_equal('John Doe', f.name)
    assert_not_nil(FakeWeb.last_request)

    FakeWeb.last_request = nil
    assert_equal('John Doe', f.name)
    assert_nil(FakeWeb.last_request)
  end

  def test_multiple_attrs_same_req
    f = FooBarUser.new :id => 42
    assert_nil(FakeWeb.last_request)
    assert_equal('John Doe', f.name)
    assert_not_nil(FakeWeb.last_request)

    FakeWeb.last_request = nil
    assert_equal('John Doe', f.name)
    assert_equal(42, f.counts[:favorites])
    assert_nil(FakeWeb.last_request)
  end

end
