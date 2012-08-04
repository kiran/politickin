class CreateCongressmen < ActiveRecord::Migration
  def change
    create_table :congressmen do |t|
      t.string :name
      t.string :party
      t.string :title
      t.string :constituency

      t.timestamps
    end
  end
end
