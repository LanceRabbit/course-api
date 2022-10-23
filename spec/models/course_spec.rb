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
require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:instructor) }
  end
end
