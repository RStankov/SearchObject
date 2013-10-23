require "search_object/version"
require "search_object/helper"
require "search_object/search"
require "search_object/plugin/paging"

module SearchObject
  def self.module(*plugins)
    return Search if plugins.empty?

    Helper.define_module do
      include Search
      plugins.each { |plugin_name| include Plugin.const_get(Helper.camelize(plugin_name)) }
    end
  end
end
