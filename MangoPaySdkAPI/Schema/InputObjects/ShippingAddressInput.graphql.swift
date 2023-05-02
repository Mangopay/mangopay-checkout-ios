// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct ShippingAddressInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      address: GraphQLNullable<BillingAddressInput> = nil,
      name: GraphQLNullable<String> = nil,
      phone: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "address": address,
        "name": name,
        "phone": phone
      ])
    }

    public var address: GraphQLNullable<BillingAddressInput> {
      get { __data["address"] }
      set { __data["address"] = newValue }
    }

    public var name: GraphQLNullable<String> {
      get { __data["name"] }
      set { __data["name"] = newValue }
    }

    public var phone: GraphQLNullable<String> {
      get { __data["phone"] }
      set { __data["phone"] = newValue }
    }
  }

}
