# coding: utf-8

User.create(name: "sample-user",
            email: "sample@email.com",
            password: "password",
            password_confirmation: "password",
            basic_start: "09:00",
            basic_finish: "17:00",
            admin: true)

User.create(name: "上長ユーザーA",
            email: "test@email.com",
            password: "password",
            password_confirmation: "password",
            basic_start: "09:00",
            basic_finish: "17:00",
            instructor_user: true
            )
            
User.create(name: "上長ユーザーB",
            email: "test2@email.com",
            password: "password",
            password_confirmation: "password",
            basic_start: "09:00",
            basic_finish: "17:00",
            instructor_user: true
            )
            
            
5.times do |n|
  name = Faker::Name.name
  email = "sample#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               basic_start: "09:00",
               basic_finish: "17:00")
               
end