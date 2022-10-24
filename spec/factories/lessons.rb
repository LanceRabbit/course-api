# == Schema Information
#
# Table name: lessons
#
#  id          :bigint           not null, primary key
#  content     :text             not null
#  description :string
#  sequence    :integer          not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  chapter_id  :bigint           not null
#
# Indexes
#
#  unique_index_chapter_id_with_sequence  (chapter_id,sequence) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (chapter_id => chapters.id)
#
FactoryBot.define do
  factory :lesson do
    title { "Lesson tilte" }
    content { "This is the content of lesson" }
    description { "This is the description of lesson" }
    sequence(:sequence) { |n| n + 1 }
    association :chapter, factory: :chapter
  end
end
