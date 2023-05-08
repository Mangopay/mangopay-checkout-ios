// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct IntentCartInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      id: GraphQLNullable<String> = nil,
      weight: GraphQLNullable<Int> = nil,
      itemCount: GraphQLNullable<Int> = nil,
      items: GraphQLNullable<[IntentCartItem]> = nil
    ) {
      __data = InputDict([
        "id": id,
        "weight": weight,
        "itemCount": itemCount,
        "items": items
      ])
    }

    public var id: GraphQLNullable<String> {
      get { __data["id"] }
      set { __data["id"] = newValue }
    }

    public var weight: GraphQLNullable<Int> {
      get { __data["weight"] }
      set { __data["weight"] = newValue }
    }

    public var itemCount: GraphQLNullable<Int> {
      get { __data["itemCount"] }
      set { __data["itemCount"] = newValue }
    }

    public var items: GraphQLNullable<[IntentCartItem]> {
      get { __data["items"] }
      set { __data["items"] = newValue }
    }
  }

}
