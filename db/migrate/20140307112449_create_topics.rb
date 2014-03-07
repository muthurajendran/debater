class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.text :question
      t.boolean :enable

      t.timestamps
    end
  end
end
