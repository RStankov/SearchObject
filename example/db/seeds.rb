User.delete_all
Post.delete_all

users = [
  User.create!(name: 'John'),
  User.create!(name: 'Jake'),
  User.create!(name: 'Jade'),
]

category_names = [
  'Books',
  'Code',
  'Design',
  'Database',
  'Education',
  'Personal',
  'News',
  'Stuff',
  'Others'
]

400.times do |i|
  Post.create!(
    user:           users.sample,
    category_name:  category_names.sample,
    title:          "Example post #{i + 1}",
    body:           'Body text',
    views_count:    rand(1000),
    likes_count:    rand(1000),
    comments_count: rand(1000),
    published:      [true, false].sample,
    created_at:     rand(30).days.ago
  )
  print '.'
end

puts ''
