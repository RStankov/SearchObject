# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'support/paging_shared_example'
require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :products, force: true do |t|
    t.string :name
    t.integer :category_id
    t.integer :price

    t.timestamps null: true
  end

  create_table :categories, force: true do |t|
    t.string :name

    t.timestamps null: true
  end
end

class Product < ActiveRecord::Base
  belongs_to :category
end

class Category < ActiveRecord::Base
end
