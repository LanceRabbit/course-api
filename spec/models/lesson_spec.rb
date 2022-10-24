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
require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:chapter) }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:sequence) }

    context 'when sequence with course_id is uniquness' do
      let(:lesson) { create(:lesson) }

      it {
        expect(lesson).to validate_uniqueness_of(:sequence).scoped_to(:chapter_id).with_message("sequence is duplicated")
      }

      it {
        expect(lesson).to validate_numericality_of(:sequence).only_integer.is_greater_than(0)
      }
    end
  end
end
