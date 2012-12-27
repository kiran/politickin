class UpdateSunlightFields < ActiveRecord::Migration
  def up
    rename_column :congressmen, :congress_address, :congress_office
    rename_column :congressmen, :open_congress_url, :congresspedia_url
    add_column :congressmen, :senate_class, :string
  end

  def down
    rename_column :congressmen, :congress_office, :congress_address
    rename_column :congressmen, :congresspedia_url, :open_congress_url
    remove_column :congressmen, :senate_class, :string
  end
end
