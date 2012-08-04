class Issue < ActiveRecord::Base
	validates_presence_of :name
	has_many :stances, :dependent => :destroy
	has_many :congressmen, :through => :stances
end
