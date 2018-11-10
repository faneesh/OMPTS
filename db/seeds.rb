# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create(area:'Kerala',email:'admin1@gmail.com',password_digest:BCrypt::Password.create('admin1'),contactno:'8735038918',name:'admin-Kerala')
Admin.create(area:'Karnataka',email:'admin2@gmail.com',password_digest:BCrypt::Password.create('admin2'),contactno:'6290475659',name:'admin-Karnataka')
Admin.create(area:'Andhra',email:'admin3@gmail.com',password_digest:BCrypt::Password.create('admin3'),contactno:'9735224830',name:'admin-Andhra')
Admin.create(area:'Tamilnadu',email:'admin4@gmail.com',password_digest:BCrypt::Password.create('admin4'),contactno:'7786026088',name:'admin-Tamilnadu')
Admin.create(area:'Telangana',email:'admin5@gmail.com',password_digest:BCrypt::Password.create('admin5'),contactno:'8735038918',name:'admin-Telangana')
Admin.create(area:'Gujarat',email:'admin6@gmail.com',password_digest:BCrypt::Password.create('admin6'),contactno:'8735038918',name:'admin-Gujarat')
