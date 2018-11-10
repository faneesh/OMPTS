class Guestuser < ApplicationRecord
	#validates :name, format: { with: }
 	 #validates :email,format: {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i},presence: true
    validates :name,length:{in:3..20}
	validates :email,format: {with:/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},length:{maximum:50}
	validates :contactno,format: {with:/\A[1-9]+[0-9]*\Z/},length:{is:10}


end
