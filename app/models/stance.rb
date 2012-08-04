class Stance < ActiveRecord::Base
  store :settings
  belongs_to :congressman
  belongs_to :issue
end
