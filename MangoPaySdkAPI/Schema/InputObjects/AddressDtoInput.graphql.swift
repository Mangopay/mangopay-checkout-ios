// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif


public extension CheckoutSchema {
  struct AddressDtoInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      line1: GraphQLNullable<String> = nil,
      line2: GraphQLNullable<String> = nil,
      city: GraphQLNullable<String> = nil,
      postalCode: GraphQLNullable<String> = nil,
      state: GraphQLNullable<String> = nil,
      country: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "line1": line1,
        "line2": line2,
        "city": city,
        "postalCode": postalCode,
        "state": state,
        "country": country
      ])
    }

    public var line1: GraphQLNullable<String> {
      get { __data["line1"] }
      set { __data["line1"] = newValue }
    }

    public var line2: GraphQLNullable<String> {
      get { __data["line2"] }
      set { __data["line2"] = newValue }
    }

    public var city: GraphQLNullable<String> {
      get { __data["city"] }
      set { __data["city"] = newValue }
    }

    public var postalCode: GraphQLNullable<String> {
      get { __data["postalCode"] }
      set { __data["postalCode"] = newValue }
    }

    public var state: GraphQLNullable<String> {
      get { __data["state"] }
      set { __data["state"] = newValue }
    }

    public var country: GraphQLNullable<String> {
      get { __data["country"] }
      set { __data["country"] = newValue }
    }
  }

}