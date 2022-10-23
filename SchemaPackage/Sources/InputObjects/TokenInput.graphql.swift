// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct TokenInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    paymentMethod: SchemaPackage.PaymentMethodInput,
    metadata: GraphQLNullable<SchemaPackage.JSON> = nil,
    externalId: GraphQLNullable<String> = nil,
    customer: GraphQLNullable<SchemaPackage.VaultCustomerInput> = nil
  ) {
    __data = InputDict([
      "paymentMethod": paymentMethod,
      "metadata": metadata,
      "externalId": externalId,
      "customer": customer
    ])
  }

  public var paymentMethod: SchemaPackage.PaymentMethodInput {
    get { __data.paymentMethod }
    set { __data.paymentMethod = newValue }
  }

  public var metadata: GraphQLNullable<SchemaPackage.JSON> {
    get { __data.metadata }
    set { __data.metadata = newValue }
  }

  public var externalId: GraphQLNullable<String> {
    get { __data.externalId }
    set { __data.externalId = newValue }
  }

  public var customer: GraphQLNullable<SchemaPackage.VaultCustomerInput> {
    get { __data.customer }
    set { __data.customer = newValue }
  }
}
