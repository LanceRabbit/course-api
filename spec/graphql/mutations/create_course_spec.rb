require "rails_helper"

RSpec.describe Mutations::CreateCourse do
  subject(:result) do
    CourseApiSchema.execute(mutation)
  end

  describe 'create_course' do
    context 'when create successfully' do
      let(:mutation) do
        <<~GRAPHQL
          mutation {
            createCourse(input: {
             title: "#{title}"
             instructor: "#{instructor}"
             description: "#{description}"
             chapters: [
               {
                 title: "ch 1",
                 sequence: 1,
                 lessons: [
                   {
                     title: "lesson 1",
                     content: "This is lesson 1",
                     sequence: 1
                   },
                   {
                     title: "lesson 2",
                     content: "This is lesson 2",
                     sequence: 2
                   }
                 ]
               },
               {
                 title: "ch 2",
                 sequence: 2,
                 lessons: [
                   {
                     title: "lesson 1",
                     content: "This is lesson 1",
                     sequence: 1
                   },
                   {
                     title: "lesson 2",
                     content: "This is lesson 2",
                     sequence: 2
                   }
                 ]
               }
             ]
            }) {
              course {
                id
                chapters {
                  id
                }
              }
              errors
            }
          }
        GRAPHQL
      end
      let(:title) { "Title from spec" }
      let(:instructor) { "Instructor from spec" }
      let(:description) { "Description from spec" }

      it 'return course' do
        expect(result.dig("data", "createCourse", "course")["id"]).not_to be_blank
      end

      it 'create course successfully' do
        expect { result }.to change(Course, :count).from(0).to(1)
      end

      it 'create chapter successfully' do
        expect { result }.to change(Chapter, :count).from(0).to(2)
      end

      it 'create lessons successfully' do
        expect { result  }.to change(Lesson, :count).from(0).to(4)
      end
    end

    context 'when the sequence of chapter are duplicated' do
      let(:mutation) do
        <<~GRAPHQL
          mutation {
            createCourse(input: {
             title: "#{title}"
             instructor: "#{instructor}"
             description: "#{description}"
             chapters: [
               {
                 title: "ch 1",
                 sequence: 1,
                 lessons: [
                   {
                     title: "lesson 1",
                     content: "This is lesson 1",
                     sequence: 1
                   },
                   {
                     title: "lesson 2",
                     content: "This is lesson 2",
                     sequence: 2
                   }
                 ]
               },
               {
                 title: "ch 2",
                 sequence: 1,
                 lessons: [
                   {
                     title: "lesson 1",
                     content: "This is lesson 1",
                     sequence: 1
                   },
                   {
                     title: "lesson 2",
                     content: "This is lesson 2",
                     sequence: 2
                   }
                 ]
               }
             ]
            }) {
              course {
                id
                chapters {
                  id
                  lessons {
                    id
                  }
                }
              }
              errors
            }
          }
        GRAPHQL
      end
      let(:title) { "Title from spec" }
      let(:instructor) { "Instructor from spec" }
      let(:description) { "Description from spec" }

      it 'return error' do
        expect { result }.not_to change(Course, :count)
        expect(result.dig("data", "createCourse")).to be_nil
        expect(result["errors"]).not_to be_empty
      end
    end

    context 'when the sequence of lesson are duplicated' do
      let(:mutation) do
        <<~GRAPHQL
          mutation {
            createCourse(input: {
             title: "#{title}"
             instructor: "#{instructor}"
             description: "#{description}"
             chapters: [
               {
                 title: "ch 1",
                 sequence: 1,
                 lessons: [
                   {
                     title: "lesson 1",
                     content: "This is lesson 1",
                     sequence: 1
                   },
                   {
                     title: "lesson 2",
                     content: "This is lesson 2",
                     sequence: 2
                   }
                 ]
               },
               {
                 title: "ch 2",
                 sequence: 2,
                 lessons: [
                   {
                     title: "lesson 1",
                     content: "This is lesson 1",
                     sequence: 1
                   },
                   {
                     title: "lesson 2",
                     content: "This is lesson 2",
                     sequence: 1
                   }
                 ]
               }
             ]
            }) {
              course {
                id
                chapters {
                  id
                }
              }
              errors
            }
          }
        GRAPHQL
      end
      let(:title) { "Title from spec" }
      let(:instructor) { "Instructor from spec" }
      let(:description) { "Description from spec" }

      it 'return error' do
        expect { result }.not_to change(Course, :count)
        expect(result.dig("data", "createCourse")).to be_nil
        expect(result["errors"]).not_to be_empty
      end
    end

    context 'when the instructor of course is nil' do
      let(:mutation) do
        <<~GRAPHQL
          mutation {
            createCourse(input: {
             title: "#{title}"
             instructor: "#{instructor}"
             description: "#{description}"
             chapters: [
               { title: "ch 1", sequence: 1  },
               { title: "ch 2", sequence: 2  }
             ]
            }) {
              course {
                id
                chapters {
                  id
                }
              }
              errors
            }
          }
        GRAPHQL
      end
      let(:title) { "Title from spec" }
      let(:instructor) { nil }
      let(:description) { nil }
      let(:chapters) do
        [
          { title: "ch 1", sequence: 1 },
          { title: "ch 2", sequence: 2 }
        ]
      end

      it 'return error' do
        expect { result }.not_to change(Course, :count)
        expect(result.dig("data", "createCourse")).to be_nil
        expect(result["errors"]).not_to be_empty
      end
    end
  end
end
