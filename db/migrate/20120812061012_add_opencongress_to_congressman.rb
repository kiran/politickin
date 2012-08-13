class AddOpencongressToCongressman < ActiveRecord::Migration
  def change
    
    add_column :congressmen, :person_id, :integer   

    #add some bills and voting stats
    add_column :congressmen, :abstains, :integer
    add_column :congressmen, :abstains_percentage, :float
    add_column :congressmen, :abstains_percentage_rank, :integer
    add_column :congressmen, :cosponsored_bills, :integer
    add_column :congressmen, :cosponsored_bills_rank, :integer
    add_column :congressmen, :sponsored_bills, :integer
    add_column :congressmen, :sponsored_bills_rank, :integer
    add_column :congressmen, :sponsored_bills_passed, :integer
    add_column :congressmen, :sponsored_bills_passed_rank, :integer
    add_column :congressmen, :cosponsored_bills_passed, :integer
    add_column :congressmen, :cosponsored_bills_passed_rank, :integer

    #add party loyalty stats
    add_column :congressmen, :with_party_percentage, :float
    add_column :congressmen, :party_votes_percentage, :float
    add_column :congressmen, :party_votes_percentage_rank, :integer

    #add polarity stats
    add_column :congressmen, :total_session_votes, :integer
    add_column :congressmen, :votes_democratic_position, :integer
    add_column :congressmen, :votes_republican_position, :integer
    add_column :congressmen, :votes_least_often_with_id, :integer
    add_column :congressmen, :votes_most_often_with_id, :integer
    add_column :congressmen, :same_party_votes_least_often_with_id, :integer
    add_column :congressmen, :opposing_party_votes_most_often_with_id, :integer
    
    #add media data
    add_column :congressmen, :metavid_id, :integer
    add_column :congressmen, :recent_news, :text
    add_column :congressmen, :recent_blogs, :text

  end
end
