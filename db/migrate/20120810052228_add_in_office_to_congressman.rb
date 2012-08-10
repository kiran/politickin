class AddInOfficeToCongressman < ActiveRecord::Migration
  def change
    add_column :congressmen, :in_office, :boolean
    add_column :congressmen, :name_suffix, :string
    add_column :congressmen, :congress_address, :string
    add_column :congressmen, :official_rss, :string
  end
end
