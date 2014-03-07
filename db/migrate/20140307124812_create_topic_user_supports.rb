class CreateTopicUserSupports < ActiveRecord::Migration
  def up
    create_table :topic_user_supports do |t|
      t.references :topic
      t.references :user
      t.boolean :support
      t.timestamps
    end
    add_index :topic_user_supports, ["topic_id","user_id"]
  end
  
  def down
    drop_table :topic_user_supports
  end
end
