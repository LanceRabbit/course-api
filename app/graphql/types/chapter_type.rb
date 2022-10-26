# frozen_string_literal: true

module Types
  class ChapterType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :course_id, Integer, null: false
    field :sequence, Integer, null: false
    field :lessons, [Types::LessonType], null: true

    def lessons
      dataloader.with(Sources::ActiveRecordObject, Chapter, :lessons).load(object.id)
    end
  end
end
