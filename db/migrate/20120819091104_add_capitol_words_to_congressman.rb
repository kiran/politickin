class AddCapitolWordsToCongressman < ActiveRecord::Migration
  def change
    add_column :congressmen, :capitolwords, :text

  end
end
