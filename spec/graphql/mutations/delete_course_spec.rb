require "rails_helper"

RSpec.describe Mutations::DeleteCourse do
  subject(:result) do
    CourseApiSchema.execute(mutation)
  end

  let(:course) { create(:course) }
  let(:mutation) do
    <<~GRAPHQL
      mutation {
        deleteCourse(input: {
          id: #{course.id}
        }) {
          course {
            id
          }
          errors
        }
      }
    GRAPHQL
  end

  describe 'delete_course' do
    before do
      create_list(:chapter, 2, course: course).each do |ch|
        ch.lessons = create_list(:lesson, 2, chapter: ch)
      end
    end

    context 'when delete course successfully' do
      it 'return course' do
        expect(result.dig("data", "deleteCourse", "course")["id"].to_i).to eq(course.id)
      end

      it 'the count of Course has changed' do
        expect { result }.to change(Course, :count).from(1).to(0)
      end

      it 'the count of Chpater has changed' do
        expect { result }.to change(Chapter, :count).from(2).to(0)
      end

      it 'the count of Lesson has changed' do
        expect { result }.to change(Lesson, :count).from(4).to(0)
      end
    end

    context 'when delete course failure' do
      it 'return error' do
        allow(Course).to receive(:find).with(course.id.to_s).and_return(course)
        allow(course).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)

        expect { result }.not_to change(Course, :count)
        expect(result.dig("data", "deleteCourse")).to be_nil
        expect(result["errors"]).not_to be_empty
      end
    end

    context 'when course not found' do
      let(:mutation) do
        <<~GRAPHQL
          mutation {
            deleteCourse(input: {
              id: 99999
            }) {
              course {
                id
              }
              errors
            }
          }
        GRAPHQL
      end

      it 'return error' do
        expect { result }.not_to change(Course, :count)
        expect(result.dig("data", "deleteCourse")).to be_nil
        expect(result["errors"]).not_to be_empty
      end
    end
  end
end
