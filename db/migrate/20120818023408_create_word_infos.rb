class CreateWordInfos < ActiveRecord::Migration
  def change
    create_table :word_infos do |t|
      t.string :word
      t.text :legislator
      t.text :chamber
      t.text :state
      t.text :party

      t.timestamps
    end
  end
end
