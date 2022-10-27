// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CustomerInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    card: GraphQLNullable<SchemaPackage.PaymentCardInput> = nil,
    customer: SchemaPackage.VaultCustomerInput
  ) {
    __data = InputDict([
      "card": card,
      "customer": customer
    ])
  }

  public var card: GraphQLNullable<SchemaPackage.PaymentCardInput> {
    get { __data.card }
    set { __data.card = newValue }
  }

  public var customer: SchemaPackage.VaultCustomerInput {
    get { __data.customer }
    set { __data.customer = newValue }
  }
}
