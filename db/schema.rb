# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120822172915) do

  create_table "congressmen", :force => true do |t|
    t.string   "first_name",                              :null => false
    t.string   "middle_name"
    t.string   "last_name",                               :null => false
    t.string   "suffix"
    t.string   "birthdate"
    t.string   "gender"
    t.string   "party"
    t.string   "title"
    t.string   "state"
    t.string   "district"
    t.string   "phone"
    t.string   "fax"
    t.string   "website"
    t.string   "webform"
    t.string   "email"
    t.string   "open_congress_url"
    t.string   "twitter_id"
    t.string   "rss"
    t.string   "facebook_id"
    t.string   "youtube_url"
    t.string   "bioguide_id"
    t.string   "eventful_id"
    t.string   "govtrack_id"
    t.string   "fec_id"
    t.string   "crp_id"
    t.string   "votesmart_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "in_office"
    t.string   "name_suffix"
    t.string   "congress_address"
    t.string   "official_rss"
    t.string   "nickname"
    t.string   "birthplace"
    t.string   "wikipedia_url"
    t.string   "religion"
    t.text     "education"
    t.text     "bills_sponsored"
    t.string   "last_elected_year"
    t.integer  "money_raised"
    t.integer  "n_earmark_requested"
    t.integer  "n_earmark_received"
    t.integer  "amt_earmark_requested"
    t.integer  "amt_earmark_received"
    t.integer  "n_vote_received"
    t.integer  "n_bills_cosponsored"
    t.integer  "n_bills_introduced"
    t.integer  "n_bills_debated"
    t.integer  "n_bills_enacted"
    t.integer  "n_speeches"
    t.integer  "words_per_speech"
    t.float    "pct_spent"
    t.float    "pct_self"
    t.float    "pct_indiv"
    t.float    "pct_pac"
    t.float    "nominate"
    t.float    "pct_vote_received"
    t.float    "predictability"
    t.integer  "person_id"
    t.integer  "abstains"
    t.string   "abstains_percentage"
    t.integer  "abstains_percentage_rank"
    t.integer  "cosponsored_bills"
    t.integer  "cosponsored_bills_rank"
    t.integer  "sponsored_bills"
    t.integer  "sponsored_bills_rank"
    t.integer  "sponsored_bills_passed"
    t.integer  "sponsored_bills_passed_rank"
    t.integer  "cosponsored_bills_passed"
    t.integer  "cosponsored_bills_passed_rank"
    t.string   "with_party_percentage"
    t.string   "party_votes_percentage"
    t.integer  "party_votes_percentage_rank"
    t.integer  "total_session_votes"
    t.integer  "votes_democratic_position"
    t.integer  "votes_republican_position"
    t.integer  "votes_least_often_with_id"
    t.integer  "votes_most_often_with_id"
    t.integer  "same_party_votes_least_often_with_id"
    t.integer  "opposing_party_votes_most_often_with_id"
    t.integer  "metavid_id"
    t.text     "recent_news"
    t.text     "recent_blogs"
    t.text     "opensecrets_contributors"
    t.text     "opensecrets_industries"
    t.text     "committees"
    t.text     "capitolwords"
  end

  create_table "word_infos", :force => true do |t|
    t.string   "word"
    t.text     "legislator"
    t.text     "chamber"
    t.text     "state"
    t.text     "party"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
