// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct IntentLocationInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      country: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "country": country
      ])
    }

    public var country: GraphQLNullable<String> {
      get { __data["country"] }
      set { __data["country"] = newValue }
    }
  }

}
