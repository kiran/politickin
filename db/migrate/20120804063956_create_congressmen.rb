class CreateCongressmen < ActiveRecord::Migration
  def change
    create_table :congressmen do |t|
      t.string :first_name, :null => false
      t.string :middle_name
      t.string :last_name, :null => false
      t.string :suffix
      t.string :birthdate
      t.string :gender

      # political info
      t.string :party
      t.string :title
      t.string :state
      t.string :district

      # contact info
      t.string :phone
      t.string :fax
      t.string :website
      t.string :webform
      t.string :email
      t.string :open_congress_url

      # web info
      t.string :twitter_id
      t.string :rss
      t.string :facebook_id
      t.string :youtube_url

      # ids
      t.string :bioguide_id
      t.string :eventful_id
      t.string :govtrack_id
      t.string :fec_id
      t.string :crp_id
      t.string :votesmart_id

      t.timestamps
    end
  end
end