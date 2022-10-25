require "rails_helper"

RSpec.describe Mutations::UpdateCourse do
  subject(:result) do
    CourseApiSchema.execute(mutation)
  end

  let(:course) { create(:course) }
  let!(:chapters) do
    create_list(:chapter, 5, course: course).each do |ch|
      ch.lessons = create_list(:lesson, 5, chapter: ch)
    end
  end

  describe 'update_course' do
    context 'when update successfully' do
      let(:mutation) do
        <<~GRAPHQL
          mutation {
            updateCourse(input: {
              id: #{course.id}
              title: "Title From spec"
              instructor: "Instructor From spec"
              chapters: [
                {
                  id: #{chapters.first.id}
                  sequence: #{chapters.last.sequence + 1}
                  title: "ch 1 from spec"
                  lessons: [
                    {
                      id: #{chapters.first.lessons.first.id}
                      title: "update lesson 1"
                      sequence: #{chapters.first.lessons.last.sequence + 1}
                    },
                    {
                      id: #{chapters.first.lessons.last.id}
                      title: "update lesson 2"
                      content: "update this conent"
                      sequence: #{chapters.first.lessons.last.sequence + 2}
                    }
                  ]
                },
                {
                  id: #{chapters.last.id}
                  title: "ch 2 from spec"
                  sequence: #{chapters.last.sequence + 2}
                }
              ]
            }) {
              course {
                id
                }
              errors
            }
          }
        GRAPHQL
      end

      it 'return course' do
        expect(result.dig("data", "updateCourse", "course")["id"].to_i).to eq(course.id)
      end

      it 'update the title of chapter' do
        result
        expect(course.chapters.where("title LIKE '%from spec'").size).to eq(2)
      end
    end

    context 'when the title of course is empty' do
      let(:mutation) do
        <<~GRAPHQL
          mutation {
            updateCourse(input: {
              id: #{course.id}
              title: ''
              instructor: "Instructor From spec"
            }) {
              course {
                id
                }
              errors
            }
          }
        GRAPHQL
      end

      it 'update failure' do
        expect(result.dig("data", "UpdateCourse")).to be_nil
        expect(result["errors"]).not_to be_empty
      end
    end

    context 'when the sequence of chapter is duplicated' do
      let(:mutation) do
        <<~GRAPHQL
          mutation {
            updateCourse(input: {
              id: #{course.id}
              title: 'Hi HI'
              instructor: "Instructor From spec"
              chapters: [
                {
                  id: #{chapters.first.id}
                  sequence: #{chapters.last.sequence}
                  title: "ch 1 from spec"
                  lessons: [
                    {
                      id: #{chapters.first.lessons.first.id}
                      title: "update lesson 1"
                      sequence: #{chapters.first.lessons.last.sequence + 1}
                    },
                    {
                      id: #{chapters.first.lessons.last.id}
                      title: "update lesson 2"
                      content: "update this conent"
                      sequence: #{chapters.first.lessons.last.sequence + 2}
                    }
                  ]
                }
              ]
            }) {
              course {
                id
                }
              errors
            }
          }
        GRAPHQL
      end

      it 'update failure' do
        expect(result.dig("data", "UpdateCourse")).to be_nil
        expect(result["errors"]).not_to be_empty
      end
    end

    context 'when the sequence of lesson is duplicated' do
      let(:mutation) do
        <<~GRAPHQL
          mutation {
            updateCourse(input: {
              id: #{course.id}
              title: 'Hi HI'
              instructor: "Instructor From spec"
              chapters: [
                {
                  id: #{chapters.first.id}
                  title: "ch 1 from spec"
                  lessons: [
                    {
                      id: #{chapters.first.lessons.first.id}
                      title: "update lesson 1"
                      sequence: #{chapters.first.lessons.last.sequence}
                    }
                  ]
                }
              ]
            }) {
              course {
                id
                }
              errors
            }
          }
        GRAPHQL
      end

      it 'update failure' do
        expect(result.dig("data", "UpdateCourse")).to be_nil
        expect(result["errors"]).not_to be_empty
      end
    end
  end
end
