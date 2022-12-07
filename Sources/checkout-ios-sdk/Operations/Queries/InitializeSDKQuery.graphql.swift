// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension CheckoutSchema {
  class InitializeSDKQuery: GraphQLQuery {
    public static let operationName: String = "initializeSDK"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        """
        query initializeSDK {
          initializeSDK
        }
        """
      ))

    public init() {}

    public struct Data: CheckoutSchema.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { CheckoutSchema.Objects.Query }
      public static var __selections: [Selection] { [
        .field("initializeSDK", Bool.self),
      ] }

      public var initializeSDK: Bool { __data["initializeSDK"] }
    }
  }

}