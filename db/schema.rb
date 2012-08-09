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

ActiveRecord::Schema.define(:version => 20120804063956) do

  create_table "congressmen", :force => true do |t|
    t.string   "first_name",        :null => false
    t.string   "middle_name"
    t.string   "last_name",         :null => false
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
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
