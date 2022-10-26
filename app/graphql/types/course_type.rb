# frozen_string_literal: true

module Types
  class CourseType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :instructor, String, null: false
    field :description, String
    field :chapters, [Types::ChapterType], null: true

    def chapters
      dataloader.with(Sources::ActiveRecordObject, Course, :chapters).load(object.id)
    end
  end
end
