// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension CheckoutSchema {
  struct PaymentMethodInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      card: GraphQLNullable<PaymentCardInput> = nil,
      bankAccount: GraphQLNullable<PaymentBankAccountInput> = nil
    ) {
      __data = InputDict([
        "card": card,
        "bankAccount": bankAccount
      ])
    }

    public var card: GraphQLNullable<PaymentCardInput> {
      get { __data["card"] }
      set { __data["card"] = newValue }
    }

    public var bankAccount: GraphQLNullable<PaymentBankAccountInput> {
      get { __data["bankAccount"] }
      set { __data["bankAccount"] = newValue }
    }
  }

}