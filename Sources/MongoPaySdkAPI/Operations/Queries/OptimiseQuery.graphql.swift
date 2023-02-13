// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension CheckoutSchema {
  class OptimiseQuery: GraphQLQuery {
    public static let operationName: String = "optimise"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        """
        query optimise($intentId: String!) {
          optimise(intentId: $intentId)
        }
        """
      ))

    public var intentId: String

    public init(intentId: String) {
      self.intentId = intentId
    }

    public var __variables: Variables? { ["intentId": intentId] }

    public struct Data: CheckoutSchema.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { CheckoutSchema.Objects.Query }
      public static var __selections: [Selection] { [
        .field("optimise", [GraphQLEnum<PaymentMethodEnum>]?.self, arguments: ["intentId": .variable("intentId")]),
      ] }

      public var optimise: [GraphQLEnum<PaymentMethodEnum>]? { __data["optimise"] }
    }
  }

}