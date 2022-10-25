# frozen_string_literal: true

module Types
  module Lessons
    class UpdateLessonInput < BaseInputObject
      argument :id, ID, required: true
      argument :title, GraphQL::Types::String, required: false
      argument :content, GraphQL::Types::String, required: false
      argument :sequence, GraphQL::Types::Int, required: false
      argument :description, GraphQL::Types::String, required: false
    end
  end
end
