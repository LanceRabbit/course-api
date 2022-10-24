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
require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to have_many(:lessons).dependent(:destroy) }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:sequence) }

    context 'when sequence with course_id is uniquness' do
      let(:chapter) { create(:chapter) }

      it {
        expect(chapter).to validate_uniqueness_of(:sequence).scoped_to(:course_id).with_message("sequence is duplicated")
      }

      it {
        expect(chapter).to validate_numericality_of(:sequence).only_integer.is_greater_than(0)
      }
    end
  end
end
