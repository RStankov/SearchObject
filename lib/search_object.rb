require "search_object/version"
require "search_object/helper"
require "search_object/search"
require "search_object/plugin/paging"

module SearchObject
  def self.module
    Search
  end
end
