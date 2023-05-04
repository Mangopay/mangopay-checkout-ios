// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  struct CustomerInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      card: GraphQLNullable<PaymentCardInput> = nil,
      customer: VaultCustomerInput
    ) {
      __data = InputDict([
        "card": card,
        "customer": customer
      ])
    }

    public var card: GraphQLNullable<PaymentCardInput> {
      get { __data["card"] }
      set { __data["card"] = newValue }
    }

    public var customer: VaultCustomerInput {
      get { __data["customer"] }
      set { __data["customer"] = newValue }
    }
  }

}
