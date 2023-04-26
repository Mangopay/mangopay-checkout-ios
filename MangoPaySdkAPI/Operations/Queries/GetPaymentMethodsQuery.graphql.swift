// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension CheckoutSchema {
  class GetPaymentMethodsQuery: GraphQLQuery {
    public static let operationName: String = "getPaymentMethods"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        """
        query getPaymentMethods($customerId: String!) {
          getPaymentMethods(customerId: $customerId) {
            __typename
            id
            token
            number
            expMonth
            expYear
            number
            isDefault
            brand
          }
        }
        """
      ))

    public var customerId: String

    public init(customerId: String) {
      self.customerId = customerId
    }

    public var __variables: Variables? { ["customerId": customerId] }

    public struct Data: CheckoutSchema.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { CheckoutSchema.Objects.Query }
      public static var __selections: [Selection] { [
        .field("getPaymentMethods", [GetPaymentMethod?]?.self, arguments: ["customerId": .variable("customerId")]),
      ] }

      public var getPaymentMethods: [GetPaymentMethod?]? { __data["getPaymentMethods"] }

      /// GetPaymentMethod
      ///
      /// Parent Type: `PaymentMethod`
      public struct GetPaymentMethod: CheckoutSchema.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentMethod }
        public static var __selections: [Selection] { [
          .field("id", String?.self),
          .field("token", String?.self),
          .field("number", String.self),
          .field("expMonth", Int.self),
          .field("expYear", Int.self),
          .field("isDefault", Bool?.self),
          .field("brand", String?.self),
        ] }

        public var id: String? { __data["id"] }
        public var token: String? { __data["token"] }
        public var number: String { __data["number"] }
        public var expMonth: Int { __data["expMonth"] }
        public var expYear: Int { __data["expYear"] }
        public var isDefault: Bool? { __data["isDefault"] }
        public var brand: String? { __data["brand"] }
      }
    }
  }

}