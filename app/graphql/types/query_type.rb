module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: needs to fix the N+1 issue
    field :courses,
          [Types::CourseType],
          null: false,
          description: "Return a list of courses"
    def courses
      Course.all
    end

    # TODO: needs to fix the N+1 issue
    field :course, Types::CourseType, null: false do
      argument :id, ID, required: true
    end
    def course(id:)
      Course.find(id)
    end
  end
end
