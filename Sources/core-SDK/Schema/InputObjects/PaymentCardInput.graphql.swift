// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension CheckoutSchema {
  struct PaymentCardInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      number: String,
      expMonth: Int,
      expYear: Int,
      cvc: GraphQLNullable<String> = nil,
      name: GraphQLNullable<String> = nil,
      billingAddress: GraphQLNullable<BillingAddressInput> = nil,
      isDefault: GraphQLNullable<Bool> = nil
    ) {
      __data = InputDict([
        "number": number,
        "expMonth": expMonth,
        "expYear": expYear,
        "cvc": cvc,
        "name": name,
        "billingAddress": billingAddress,
        "isDefault": isDefault
      ])
    }

    public var number: String {
      get { __data["number"] }
      set { __data["number"] = newValue }
    }

    public var expMonth: Int {
      get { __data["expMonth"] }
      set { __data["expMonth"] = newValue }
    }

    public var expYear: Int {
      get { __data["expYear"] }
      set { __data["expYear"] = newValue }
    }

    public var cvc: GraphQLNullable<String> {
      get { __data["cvc"] }
      set { __data["cvc"] = newValue }
    }

    public var name: GraphQLNullable<String> {
      get { __data["name"] }
      set { __data["name"] = newValue }
    }

    public var billingAddress: GraphQLNullable<BillingAddressInput> {
      get { __data["billingAddress"] }
      set { __data["billingAddress"] = newValue }
    }

    public var isDefault: GraphQLNullable<Bool> {
      get { __data["isDefault"] }
      set { __data["isDefault"] = newValue }
    }
  }

}