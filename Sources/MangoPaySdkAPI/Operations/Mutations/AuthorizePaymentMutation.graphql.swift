// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension CheckoutSchema {
  class AuthorizePaymentMutation: GraphQLMutation {
    public static let operationName: String = "authorizePayment"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        """
        mutation authorizePayment($authorisePayment: AuthorisedPaymentInput!) {
          authorizePayment(authorisePayment: $authorisePayment) {
            __typename
            id
            status
          }
        }
        """
      ))

    public var authorisePayment: AuthorisedPaymentInput

    public init(authorisePayment: AuthorisedPaymentInput) {
      self.authorisePayment = authorisePayment
    }

    public var __variables: Variables? { ["authorisePayment": authorisePayment] }

    public struct Data: CheckoutSchema.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { CheckoutSchema.Objects.Mutation }
      public static var __selections: [Selection] { [
        .field("authorizePayment", AuthorizePayment?.self, arguments: ["authorisePayment": .variable("authorisePayment")]),
      ] }

      public var authorizePayment: AuthorizePayment? { __data["authorizePayment"] }

      /// AuthorizePayment
      ///
      /// Parent Type: `Payment`
      public struct AuthorizePayment: CheckoutSchema.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { CheckoutSchema.Objects.Payment }
        public static var __selections: [Selection] { [
          .field("id", ID.self),
          .field("status", GraphQLEnum<PaymentStatus>?.self),
        ] }

        public var id: ID { __data["id"] }
        public var status: GraphQLEnum<PaymentStatus>? { __data["status"] }
      }
    }
  }

}