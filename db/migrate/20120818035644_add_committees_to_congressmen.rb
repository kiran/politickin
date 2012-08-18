class AddCommitteesToCongressmen < ActiveRecord::Migration
  def change
    add_column :congressmen, :committees, :text

  end
end
