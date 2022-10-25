# frozen_string_literal: true

module Types
  module Lessons
    class CreateLessonInput < BaseInputObject
      argument :title, GraphQL::Types::String, required: true
      argument :content, GraphQL::Types::String, required: true
      argument :sequence, GraphQL::Types::Int, required: true
      argument :description, GraphQL::Types::String, required: false
    end
  end
end
