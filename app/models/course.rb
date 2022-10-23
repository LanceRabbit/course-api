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
class Course < ApplicationRecord
  validates :title, :instructor, presence: true
end
