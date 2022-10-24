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
  end
end
