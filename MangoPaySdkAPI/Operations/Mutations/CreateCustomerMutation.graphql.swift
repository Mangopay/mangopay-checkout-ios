// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
@_exported import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  class CreateCustomerMutation: GraphQLMutation {
    public static let operationName: String = "createCustomer"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        """
        mutation createCustomer($data: CustomerInput!) {
          createCustomer(data: $data)
        }
        """
      ))

    public var data: CustomerInput

    public init(data: CustomerInput) {
      self.data = data
    }

    public var __variables: Variables? { ["data": data] }

    public struct Data: CheckoutSchema.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { CheckoutSchema.Objects.Mutation }
      public static var __selections: [Selection] { [
        .field("createCustomer", String.self, arguments: ["data": .variable("data")]),
      ] }

      public var createCustomer: String { __data["createCustomer"] }
    }
  }

}
