class Issue < ActiveRecord::Base
  attr_accessible :code,
		 :resolved,
		 :row_id,
		 :tablename,
		 :teacher_id

	validates :code, :presence => true, :numericality => :only_integer => true
	validates :resolved, :presence => true
	validates :row_id, :presence => true
	validates :tablename, :presence => true
	validates :teacher_id, :presence => true
end
