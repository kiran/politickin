class AddOpensecretsToCongressman < ActiveRecord::Migration
  def change

    #add financial data
    add_column :congressmen, :opensecrets_contributors, :text
    add_column :congressmen, :opensecrets_industries, :text

  end
end
