# frozen_string_literal: true

module Mutations
  class UpdateCourse < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :instructor, String, required: false
    argument :description, String, required: false
    argument :chapters, [Types::Chapters::UpdateChapterInput], required: false

    field :course, Types::CourseType, null: false
    field :errors, [String], null: false

    def resolve(id:, **args)
      @course = Course.find(id)

      ActiveRecord::Base.transaction do
        @course.update!(course_params(args))
        chapters = fetch_chapters(args)

        # OPTIMIZE: use upsert_all instead of update!
        if chapters.present?
          current_chapters = @course.chapters.where(id: chapter_ids(chapters))

          current_chapters.each do |ch|
            chapter = detect_chapter(ch, chapters)
            ch.update!(chapter_params(chapter))

            next if chapter.lessons.blank?

            current_lessons = ch.lessons.where(id: lesson_ids(chapter.lessons))

            current_lessons.each do |lesson|
              lesson.update!(lesson_params(lesson, chapter.lessons))
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

    def course_params(args)
      args.slice(:title, :description, :instructor)
    end

    def fetch_chapters(args)
      args.slice(:chapters)[:chapters]
    end

    def detect_chapter(chapter, chapters)
      chapters.detect { |ch| ch.id.to_i == chapter.id }
    end

    def chapter_ids(chapters)
      chapters.pluck(:id)
    end

    def lesson_ids(lessons)
      lessons.pluck(:id)
    end

    def chapter_params(chapter)
      {
        'title' => chapter.title,
        'sequence' => chapter.sequence
      }.compact_blank!
    end

    def lesson_params(lesson, lessons)
      data = lessons.detect { |target| target.id.to_i == lesson.id }

      {
        'title' => data.title,
        'content' => data.content,
        'sequence' => data.sequence,
        'description' => data.description
      }.compact_blank!
    end
  end
end
