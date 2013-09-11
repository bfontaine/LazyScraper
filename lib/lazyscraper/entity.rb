#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require 'nokogiri'
require 'open-uri'

module LazyScraper

  BASEURI = ''

  module Hookable
    @@hooks = []

    def attr_hook(path, *attrs, &parser)
      return unless block_given? && attrs.length > 0

      cpt = @@hooks.length

      attrs.each do |a|
        define_method(a) do
          return @@hooks[cpt][a] if @@hooks[cpt].is_a?(Hash)

          path = path.gsub(/:([a-z][_a-z0-9]*)/i) do
            self.send($1.to_sym).to_s
          end

          doc = Nokogiri::HTML(open(BASEURI + path))
          parsed_attrs = {}
          parser.call(doc, parsed_attrs)

          @@hooks << parsed_attrs
          parsed_attrs[a]
        end
      end

    end
  end

  class Entity
    extend Hookable

    def initialize **attrs

      # May be too much hacky
      meta = class << self; self; end
      attrs.each do |a,v|
        meta.send(:define_method, a) { v }
      end
    end
  end
end
