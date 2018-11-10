class Rescueteam < ApplicationRecord
	has_secure_password
	validates :name,length:{in:3..20}

	validates :area,presence:true
	validates :email,format: {with:/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},length:{maximum:50},uniqueness:true
	validates :contactno,format: {with:/\A[1-9]+[0-9]*\Z/},length:{is:10}
end
