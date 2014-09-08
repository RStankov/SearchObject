class PostSearch
  include SearchObject.module(:model, :sorting, :will_paginate)

  scope { Post.all }

  sort_by :created_at, :views_count, :likes_count, :comments_count

  per_page 15

  min_per_page 10
  max_per_page 100

  option :user_id
  option :category_name

  option :title do |scope, value|
    scope.where 'title LIKE ?', escape_search_term(value)
  end

  option :published do |scope, value|
    scope.where published: true if value.present?
  end

  option :term do |scope, value|
    scope.where 'title LIKE :term OR body LIKE :term', term: escape_search_term(value)
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

  def parse_date(date)
    Date.strptime(date, '%Y-%m-%d') rescue nil
  end

  def escape_search_term(term)
    "%#{term.gsub(/\s+/, '%')}%"
  end
end
