class Missingdetail < ApplicationRecord
	validates :name,length:{minimum:3}
	
	validates :address,length:{minimum:3}

	#validates :area,presence:true
	#validates :email,format: {with:/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},presence:true,length:{maximum:50},uniqueness:true
	#validates :contactno,format: {with:/\A[1-9]+[0-9]*\Z/},length:{is:10},presence:true

end
