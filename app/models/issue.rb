class Issue < ActiveRecord::Base
  	attr_accessible :code,
					:resolved,
					:row_id,
					:tablename,
					:teacher_id,
					:name

	validates :code, :presence => true
	validates :resolved, :inclusion => {:in => [true, false]}
	validates :row_id, :presence => true
	validates :tablename, :presence => true
	validates :teacher_id, :presence => true
	validates :name, :presence => true

end
