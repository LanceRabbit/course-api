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
class Chapter < ApplicationRecord
  has_many :lessons, dependent: :destroy
  belongs_to :course, optional: false

  validates :title, presence: true
  validates :sequence, numericality: {
                         only_integer: true,
                         greater_than: 0
                       },
                       presence: true,
                       uniqueness: {
                         scope: :course_id,
                         message: "sequence is duplicated"
                       }
end
