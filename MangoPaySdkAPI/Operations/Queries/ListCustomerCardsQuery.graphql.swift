// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
@_exported import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  class ListCustomerCardsQuery: GraphQLQuery {
    public static let operationName: String = "listCustomerCards"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        """
        query listCustomerCards($vaultCustomerId: String!) {
          listCustomerCards(vaultCustomerId: $vaultCustomerId) {
            __typename
            token
            brand
            number
            expMonth
            expYear
            name
            type
            product
            bankName
            metadata
            externalId
            fingerprint
            isDefault
            systemCreated
            systemUpdated
            billingAddress {
              __typename
              line1
              line2
              city
              postalCode
              state
              country
            }
          }
        }
        """
      ))

    public var vaultCustomerId: String

    public init(vaultCustomerId: String) {
      self.vaultCustomerId = vaultCustomerId
    }

    public var __variables: Variables? { ["vaultCustomerId": vaultCustomerId] }

    public struct Data: CheckoutSchema.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { CheckoutSchema.Objects.Query }
      public static var __selections: [Selection] { [
        .field("listCustomerCards", [ListCustomerCard?]?.self, arguments: ["vaultCustomerId": .variable("vaultCustomerId")]),
      ] }

      public var listCustomerCards: [ListCustomerCard?]? { __data["listCustomerCards"] }

      /// ListCustomerCard
      ///
      /// Parent Type: `PaymentMethod`
      public struct ListCustomerCard: CheckoutSchema.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentMethod }
        public static var __selections: [Selection] { [
          .field("token", String?.self),
          .field("brand", String?.self),
          .field("number", String.self),
          .field("expMonth", Int.self),
          .field("expYear", Int.self),
          .field("name", String?.self),
          .field("type", String?.self),
          .field("product", String?.self),
          .field("bankName", String?.self),
          .field("metadata", JSON?.self),
          .field("externalId", String?.self),
          .field("fingerprint", String?.self),
          .field("isDefault", Bool?.self),
          .field("systemCreated", DateTime?.self),
          .field("systemUpdated", DateTime?.self),
          .field("billingAddress", BillingAddress?.self),
        ] }

        public var token: String? { __data["token"] }
        public var brand: String? { __data["brand"] }
        public var number: String { __data["number"] }
        public var expMonth: Int { __data["expMonth"] }
        public var expYear: Int { __data["expYear"] }
        public var name: String? { __data["name"] }
        public var type: String? { __data["type"] }
        public var product: String? { __data["product"] }
        public var bankName: String? { __data["bankName"] }
        public var metadata: JSON? { __data["metadata"] }
        public var externalId: String? { __data["externalId"] }
        public var fingerprint: String? { __data["fingerprint"] }
        public var isDefault: Bool? { __data["isDefault"] }
        public var systemCreated: DateTime? { __data["systemCreated"] }
        public var systemUpdated: DateTime? { __data["systemUpdated"] }
        public var billingAddress: BillingAddress? { __data["billingAddress"] }

        /// ListCustomerCard.BillingAddress
        ///
        /// Parent Type: `BillingAddressApi`
        public struct BillingAddress: CheckoutSchema.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { CheckoutSchema.Objects.BillingAddressApi }
          public static var __selections: [Selection] { [
            .field("line1", String?.self),
            .field("line2", String?.self),
            .field("city", String?.self),
            .field("postalCode", String?.self),
            .field("state", String?.self),
            .field("country", String?.self),
          ] }

          public var line1: String? { __data["line1"] }
          public var line2: String? { __data["line2"] }
          public var city: String? { __data["city"] }
          public var postalCode: String? { __data["postalCode"] }
          public var state: String? { __data["state"] }
          public var country: String? { __data["country"] }
        }
      }
    }
  }

}
