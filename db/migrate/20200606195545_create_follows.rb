class CreateFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :follows do |t|
      t.references :user, index: true, foreign_key: true
      t.references :follow, index: true
      t.timestamps
    end
    add_foreign_key :follows, :users, column: :follow_id
  end
end
