class ChangeOpencongressFloatsToStrings < ActiveRecord::Migration
  def up
    change_column :congressmen, :abstains_percentage, :string
    change_column :congressmen, :with_party_percentage, :string
    change_column :congressmen, :party_votes_percentage, :string
  end

  def down
    change_column :congressmen, :abstains_percentage, :float
    change_column :congressmen, :with_party_percentage, :float
    change_column :congressmen, :party_votes_percentage, :float
  end
end
