# frozen_string_literal: true

require 'spec_helper'

describe PostSearch do
  let(:user) { create_user }

  def create_user
    User.create! name: "User #{User.count + 1}"
  end

  def create(attributes = {})
    Post.create! attributes.reverse_merge(
      user: user,
      title: 'Title',
      body: 'Body',
      category_name: 'Tech',
      published: true
    )
  end

  def expect_search(options)
    expect(PostSearch.new(filters: options, page: 0).results)
  end

  it 'can search by category name' do
    post = create category_name: 'Personal'
    _other = create category_name: 'Other'

    expect_search(category_name: 'Personal').to eq [post]
  end

  it 'can search by user_id' do
    post = create user: create_user
    _other = create user: create_user

    expect_search(user_id: post.user_id).to eq [post]
  end

  it 'can search by title' do
    post = create title: 'Title'
    _other = create title: 'Other'

    expect_search(title: 'itl').to eq [post]
  end

  it 'can search by published' do
    post = create published: true
    _other = create published: false

    expect_search(published: true).to eq [post]
  end

  it 'can search by term' do
    post_with_body  = create body: 'pattern'
    post_with_title = create title: 'pattern'
    _other = create

    expect_search(term: 'pattern').to eq [post_with_title, post_with_body]
  end

  it 'can search by created after' do
    post = create created_at: 1.month.ago
    _other = create created_at: 3.month.ago

    expect_search(created_after: 2.month.ago.strftime('%Y-%m-%d')).to eq [post]
  end

  it 'can search by created before' do
    post = create created_at: 3.month.ago
    _other = create created_at: 1.month.ago

    expect_search(created_before: 2.month.ago.strftime('%Y-%m-%d')).to eq [post]
  end

  it 'can sort by views count' do
    post3 = create views_count: 3
    post2 = create views_count: 2
    post1 = create views_count: 1

    expect_search(sort: 'views_count').to eq [post3, post2, post1]
  end
end
