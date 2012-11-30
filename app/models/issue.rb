class Issue < ActiveRecord::Base
  	attr_accessible :code,
					:resolved,
					:teacher_id,
					:name,
					:scansheet_id

	belongs_to :scansheet

	validates :code, :presence => true
	validates :resolved, :inclusion => {:in => [true, false]}
	validates :teacher_id, :presence => true
	validates :name, :presence => true
	validates :scansheet, :presence => true

end
