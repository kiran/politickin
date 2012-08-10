class AddWatchdogToCongressman < ActiveRecord::Migration
  def change
    add_column :congressmen, :nickname, :string
    add_column :congressmen, :birthplace, :string
    add_column :congressmen, :wikipedia_url, :string
    add_column :congressmen, :religion, :string
    add_column :congressmen, :education, :text
    add_column :congressmen, :bills_sponsored, :text
    add_column :congressmen, :last_elected_year, :string

    add_column :congressmen, :money_raised, :integer
    add_column :congressmen, :n_earmark_requested, :integer
    add_column :congressmen, :n_earmark_received, :integer
    add_column :congressmen, :amt_earmark_requested, :integer
    add_column :congressmen, :amt_earmark_received, :integer
    add_column :congressmen, :n_vote_received, :integer
    add_column :congressmen, :n_bills_cosponsored, :integer
    add_column :congressmen, :n_bills_introduced, :integer
    add_column :congressmen, :n_bills_debated, :integer
    add_column :congressmen, :n_bills_enacted, :integer
    add_column :congressmen, :n_speeches, :integer
    add_column :congressmen, :words_per_speech, :integer

    add_column :congressmen, :pct_spent, :float
    add_column :congressmen, :pct_self, :float
    add_column :congressmen, :pct_indiv, :float
    add_column :congressmen, :pct_pac, :float
    add_column :congressmen, :nominate, :float
    add_column :congressmen, :pct_vote_received, :float
    add_column :congressmen, :predictability, :float
  end
end
