# == Schema Information
#
# Table name: chapters
#
#  id         :bigint           not null, primary key
#  sequence   :integer          not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#
# Indexes
#
#  unique_index_course_id_with_sequence  (course_id,sequence) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
FactoryBot.define do
  factory :chapter do
    title { "Chapter title" }
    add_attribute(:sequence) { 1 }
    association :course, factory: :course
  end
end
