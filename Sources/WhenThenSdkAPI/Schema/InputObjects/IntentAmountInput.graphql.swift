// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension CheckoutSchema {
  struct IntentAmountInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      amount: GraphQLNullable<Int> = nil,
      currency: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "amount": amount,
        "currency": currency
      ])
    }

    public var amount: GraphQLNullable<Int> {
      get { __data["amount"] }
      set { __data["amount"] = newValue }
    }

    public var currency: GraphQLNullable<String> {
      get { __data["currency"] }
      set { __data["currency"] = newValue }
    }
  }

}