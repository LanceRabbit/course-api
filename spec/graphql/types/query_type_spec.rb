require "rails_helper"

RSpec.describe Types::QueryType do
  describe "courses" do
    subject(:result) do
      CourseApiSchema.execute(query).as_json
    end

    let!(:course) { create(:course) }
    let!(:chapter) { create(:chapter, course: course) }
    let!(:lessons) { create_list(:lesson, 5, chapter: chapter) }
    let(:expected_lessons) do
      lessons.map do |lesson|
        lesson.id.to_s
      end
    end

    let(:query) do
      %(query {
        courses {
          id
          chapters {
            id
            lessons {
              id
            }
          }
        }
      })
    end

    it "returns all courses" do
      expect(result.dig("data", "courses").pluck("id")).to match_array([course.id.to_s])
    end

    it 'returns data contains chapters' do
      expect(result.dig("data", "courses").map do |course|
               course["chapters"].pluck("id")
             end.flatten).to match_array([chapter.id.to_s])
    end

    it 'returne data contains lessons' do
      expect(result.dig("data", "courses").map do |course|
               course["chapters"].map do |ch|
                 ch["lessons"].pluck("id")
               end
             end.flatten).to match_array(expected_lessons)
    end
  end
end
