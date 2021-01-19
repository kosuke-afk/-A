# coding: utf-8

User.create(name: "sample-user",
            email: "sample@email.com",
            password: "password",
            password_confirmation: "password",
            basic_start: "09:00",
            basic_finish: "17:00",
            uid: 1,
            employee_number: 1,
            admin: true)

User.create(name: "上長ユーザーA",
            email: "test@email.com",
            password: "password",
            password_confirmation: "password",
            basic_start: "09:00",
            basic_finish: "17:00",
            uid: 2,
            employee_number: 2,
            superior: true
            )
            
User.create(name: "上長ユーザーB",
            email: "test2@email.com",
            password: "password",
            password_confirmation: "password",
            basic_start: "09:00",
            basic_finish: "17:00",
            uid: 3,
            employee_number: 3,
            superior: true
            )
            
            
5.times do |n|
  name = Faker::Name.name
  email = "sample#{n+1}@email.com"
  password = "password"
  uid = n + 4
  employee_number = n + 4
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               basic_start: "09:00",
               basic_finish: "17:00",
               uid: uid,
               employee_number: employee_number)
               
end