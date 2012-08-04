class AddJsonToCongressmen < ActiveRecord::Migration
  def change
    add_column :congressmen, :json, :text
    add_column :congressmen, :json_stances, :text

  end
end
