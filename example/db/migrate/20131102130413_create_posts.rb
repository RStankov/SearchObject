class CreatePosts < ActiveRecord::Migration[4.2]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :body, null: false
      t.string :category_name, null: false
      t.integer :views_count, null: false, default: 0
      t.integer :likes_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.boolean :published, null: false, default: false
      t.timestamps
    end

    add_index :posts, :user_id
  end
end
