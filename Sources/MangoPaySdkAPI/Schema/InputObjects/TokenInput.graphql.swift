// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension CheckoutSchema {
  struct TokenInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      paymentMethod: PaymentMethodInput,
      metadata: GraphQLNullable<JSON> = nil,
      externalId: GraphQLNullable<String> = nil,
      customer: GraphQLNullable<VaultCustomerInput> = nil
    ) {
      __data = InputDict([
        "paymentMethod": paymentMethod,
        "metadata": metadata,
        "externalId": externalId,
        "customer": customer
      ])
    }

    public var paymentMethod: PaymentMethodInput {
      get { __data["paymentMethod"] }
      set { __data["paymentMethod"] = newValue }
    }

    public var metadata: GraphQLNullable<JSON> {
      get { __data["metadata"] }
      set { __data["metadata"] = newValue }
    }

    public var externalId: GraphQLNullable<String> {
      get { __data["externalId"] }
      set { __data["externalId"] = newValue }
    }

    public var customer: GraphQLNullable<VaultCustomerInput> {
      get { __data["customer"] }
      set { __data["customer"] = newValue }
    }
  }

}