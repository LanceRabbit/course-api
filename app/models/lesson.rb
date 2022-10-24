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
class Lesson < ApplicationRecord
  belongs_to :chapter, optional: false

  validates :title, :content, presence: true
  validates :sequence, numericality: {
                         only_integer: true,
                         greater_than: 0
                       },
                       presence: true,
                       uniqueness: {
                         scope: :chapter_id,
                         message: "sequence is duplicated"
                       }
end
