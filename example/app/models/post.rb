# frozen_string_literal: true

class Post < ActiveRecord::Base
  belongs_to :user

  validates :user,           presence: true
  validates :title,          presence: true
  validates :body,           presence: true
  validates :category_name,  presence: true
  validates :views_count,    numericality: true
  validates :likes_count,    numericality: true
  validates :comments_count, numericality: true

  delegate :name, to: :user, prefix: true
end
