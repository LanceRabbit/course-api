# == Schema Information
#
# Table name: courses
#
#  id          :bigint           not null, primary key
#  description :string
#  instructor  :string           not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :course do
    title { "New Course" }
    instructor { "Hahow Instructor" }
    description { "Course Description" }
  end
end
