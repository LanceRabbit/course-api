# frozen_string_literal: true

module Types
  class ChapterType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :course_id, Integer, null: false
    field :sequence, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
