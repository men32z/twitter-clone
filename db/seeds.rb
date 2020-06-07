# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create({
  email: "test1@test1.com",
  username: "usernametest1",
  name: Faker::Name.name,
  password: '123123123'
})
user2 = User.create({
  email: "test2@test2.com",
  username: "usernametest2",
  name: Faker::Name.name,
  password: '123123123'
})

Follow.create(user_id: user.id, follow_id: user2.id)

15.times do |x|
  user.posts.create(message: "this is a tweet #{x}")
end