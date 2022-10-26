# frozen_string_literal: true

module Mutations
  class DeleteCourse < Mutations::BaseMutation
    argument :id, ID, required: true

    field :course, Types::CourseType, null: false
    field :errors, [String], null: false

    def resolve(id:)
      @course = Course.find(id)

      @course.destroy!

      {
        course: @course,
        errors: []
      }
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordNotDestroyed => e
      GraphQL::ExecutionError.new(
        "Delete course occured #{e.class}: #{e.message}"
      )
    end
  end
end
