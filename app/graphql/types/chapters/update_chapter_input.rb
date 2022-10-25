# frozen_string_literal: true

module Types
  module Chapters
    class UpdateChapterInput < BaseInputObject
      argument :id, ID, required: true
      argument :title, GraphQL::Types::String, required: false
      argument :sequence, GraphQL::Types::Int, required: false
      argument :lessons, [Types::Lessons::UpdateLessonInput], required: false
    end
  end
end
