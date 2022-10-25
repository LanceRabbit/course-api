# frozen_string_literal: true

module Mutations
  class CreateCourse < Mutations::BaseMutation
    argument :title, String, required: true
    argument :instructor, String, required: true
    argument :description, String, required: false
    argument :chapters, [Types::Chapters::CreateChapterInput], required: false

    field :course, Types::CourseType, null: false
    field :errors, [String], null: false

    def resolve(title:, instructor:, description: nil, chapters: [])
      ActiveRecord::Base.transaction do
        @course = Course.create!(title: title, instructor: instructor, description: description)

        # OPTIMIZE: use insert_all instead of creaet!
        if chapters.present?
          chapters.each do |ch|
            chapter = @course.chapters.create!(title: ch.title, sequence: ch.sequence)
            next if ch.lessons.blank?

            ch.lessons.each do |lesson|
              chapter.lessons.create!(
                title: lesson.title,
                content: lesson.content,
                sequence: lesson.sequence,
                description: lesson.description
              )
            end
          end
        end
      end

      {
        course: @course,
        errors: []
      }
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(
        "Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}"
      )
    end
  end
end
