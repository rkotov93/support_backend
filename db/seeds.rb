# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

FactoryGirl.create(:user, role: 'admin', email: 'admin@example.com', password: 'qweasd')

2.times.each do
  FactoryGirl.create(:user, role: 'support')
end

6.times.each do
  FactoryGirl.create(:user)
end

customers = User.where(role: 'customer').first(2)

8.times.each do
  FactoryGirl.create(:ticket, author: customers.sample)
end
