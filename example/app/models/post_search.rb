# frozen_string_literal: true

class PostSearch
  include SearchObject.module(:model, :sorting, :will_paginate, :enum)

  scope { Post.includes(:user).all }

  sort_by :id, :created_at, :views_count, :likes_count, :comments_count

  per_page 15

  min_per_page 10
  max_per_page 100

  option :user_id
  option :category_name

  option :term, with: :apply_term

  option :rating, enum: %i[low high]

  option :title do |scope, value|
    scope.where 'title LIKE ?', escape_search_term(value) if value.present?
  end

  option :published do |scope, value|
    scope.where published: true if value.present? && value != '0'
  end

  option :created_after do |scope, value|
    date = parse_date value
    scope.where('DATE(created_at) >= ?', date) if date.present?
  end

  option :created_before do |scope, value|
    date = parse_date value
    scope.where('DATE(created_at) <= ?', date) if date.present?
  end

  private

  def apply_term(scope, value)
    scope.where 'title LIKE :term OR body LIKE :term', term: escape_search_term(value) if value.present?
  end

  def apply_rating_with_low(scope)
    scope.where 'views_count < 100'
  end

  def apply_rating_with_high(scope)
    scope.where 'views_count > 500'
  end

  def parse_date(value)
    Date.parse(value).strftime('%Y-%m-%d')
  rescue ArgumentError
    nil
  end

  def escape_search_term(term)
    "%#{term.gsub(/\s+/, '%')}%"
  end
end
