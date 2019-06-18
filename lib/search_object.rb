# frozen_string_literal: true

require 'search_object/version'
require 'search_object/errors'
require 'search_object/helper'
require 'search_object/base'
require 'search_object/search'
require 'search_object/plugin/model'
require 'search_object/plugin/paging'
require 'search_object/plugin/will_paginate'
require 'search_object/plugin/kaminari'
require 'search_object/plugin/sorting'
require 'search_object/plugin/enum'

module SearchObject
  def self.module(*plugins)
    return Base if plugins.empty?

    Helper.define_module do
      include Base
      plugins.each { |plugin_name| include Plugin.const_get(Helper.camelize(plugin_name)) }
    end
  end
end
