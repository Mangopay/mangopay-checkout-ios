// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AuthorisedPaymentInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    transactionId: GraphQLNullable<String> = nil,
    orderId: GraphQLNullable<String> = nil,
    flowId: GraphQLNullable<String> = nil,
    intentId: GraphQLNullable<String> = nil,
    currencyCode: GraphQLNullable<String> = nil,
    amount: GraphQLNullable<SchemaPackage.Long> = nil,
    paymentMethod: SchemaPackage.PaymentMethodDtoInput,
    customer: GraphQLNullable<SchemaPackage.PaymentMethodCustomerDtoInput> = nil,
    description: GraphQLNullable<String> = nil,
    metadata: GraphQLNullable<SchemaPackage.JSON> = nil,
    perform3DSecure: GraphQLNullable<SchemaPackage.ThreeDSecureDtoInput> = nil,
    apmRedirectUrl: GraphQLNullable<String> = nil,
    fraud: GraphQLNullable<SchemaPackage.JSON> = nil,
    headlessMode: GraphQLNullable<Bool> = nil,
    paymentProcessorConnectionId: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "transactionId": transactionId,
      "orderId": orderId,
      "flowId": flowId,
      "intentId": intentId,
      "currencyCode": currencyCode,
      "amount": amount,
      "paymentMethod": paymentMethod,
      "customer": customer,
      "description": description,
      "metadata": metadata,
      "perform3DSecure": perform3DSecure,
      "apmRedirectUrl": apmRedirectUrl,
      "fraud": fraud,
      "headlessMode": headlessMode,
      "paymentProcessorConnectionId": paymentProcessorConnectionId
    ])
  }

  public var transactionId: GraphQLNullable<String> {
    get { __data.transactionId }
    set { __data.transactionId = newValue }
  }

  public var orderId: GraphQLNullable<String> {
    get { __data.orderId }
    set { __data.orderId = newValue }
  }

  public var flowId: GraphQLNullable<String> {
    get { __data.flowId }
    set { __data.flowId = newValue }
  }

  public var intentId: GraphQLNullable<String> {
    get { __data.intentId }
    set { __data.intentId = newValue }
  }

  public var currencyCode: GraphQLNullable<String> {
    get { __data.currencyCode }
    set { __data.currencyCode = newValue }
  }

  public var amount: GraphQLNullable<SchemaPackage.Long> {
    get { __data.amount }
    set { __data.amount = newValue }
  }

  public var paymentMethod: SchemaPackage.PaymentMethodDtoInput {
    get { __data.paymentMethod }
    set { __data.paymentMethod = newValue }
  }

  public var customer: GraphQLNullable<SchemaPackage.PaymentMethodCustomerDtoInput> {
    get { __data.customer }
    set { __data.customer = newValue }
  }

  public var description: GraphQLNullable<String> {
    get { __data.description }
    set { __data.description = newValue }
  }

  public var metadata: GraphQLNullable<SchemaPackage.JSON> {
    get { __data.metadata }
    set { __data.metadata = newValue }
  }

  public var perform3DSecure: GraphQLNullable<SchemaPackage.ThreeDSecureDtoInput> {
    get { __data.perform3DSecure }
    set { __data.perform3DSecure = newValue }
  }

  public var apmRedirectUrl: GraphQLNullable<String> {
    get { __data.apmRedirectUrl }
    set { __data.apmRedirectUrl = newValue }
  }

  public var fraud: GraphQLNullable<SchemaPackage.JSON> {
    get { __data.fraud }
    set { __data.fraud = newValue }
  }

  public var headlessMode: GraphQLNullable<Bool> {
    get { __data.headlessMode }
    set { __data.headlessMode = newValue }
  }

  public var paymentProcessorConnectionId: GraphQLNullable<String> {
    get { __data.paymentProcessorConnectionId }
    set { __data.paymentProcessorConnectionId = newValue }
  }
}
