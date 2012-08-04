class CreateStances < ActiveRecord::Migration
  def change
    create_table :stances do |t|
      t.references :congressman
      t.references :issue
      t.text :subtopics

      t.timestamps
    end
    add_index :stances, :congressman_id
    add_index :stances, :issue_id
  end
end
