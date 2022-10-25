# frozen_string_literal: true

module Types
  module Chapters
    class CreateChapterInput < BaseInputObject
      argument :title, GraphQL::Types::String, required: true
      argument :sequence, GraphQL::Types::Int, required: true
      argument :lessons, [Types::Lessons::CreateLessonInput], required: false
    end
  end
end
