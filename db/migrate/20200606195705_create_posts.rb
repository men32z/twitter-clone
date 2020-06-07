class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :message, limit: 280
      t.timestamps
    end
  end
end
