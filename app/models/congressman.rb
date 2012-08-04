class Congressman < ActiveRecord::Base
	validates_presence_of :name, :party, :title, :constituency
	has_many :stances, :dependent => :destroy
	has_many :issues, :through => :stances
end
