# frozen_string_literal: true

module Types
  class CourseType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :instructor, String, null: false
    field :description, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :chapter_count, Integer, null: true
    field :chapters, [Types::ChapterType], null: true

    def chapter_count
      object.chapters.size
    end

    delegate :chapters, to: :object
  end
end
