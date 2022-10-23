// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PaymentMethodDtoInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    type: String,
    token: GraphQLNullable<String> = nil,
    walletToken: GraphQLNullable<String> = nil,
    card: GraphQLNullable<SchemaPackage.CardDtoInput> = nil,
    googlePay: GraphQLNullable<SchemaPackage.GooglePayInput> = nil
  ) {
    __data = InputDict([
      "type": type,
      "token": token,
      "walletToken": walletToken,
      "card": card,
      "googlePay": googlePay
    ])
  }

  public var type: String {
    get { __data.type }
    set { __data.type = newValue }
  }

  public var token: GraphQLNullable<String> {
    get { __data.token }
    set { __data.token = newValue }
  }

  public var walletToken: GraphQLNullable<String> {
    get { __data.walletToken }
    set { __data.walletToken = newValue }
  }

  public var card: GraphQLNullable<SchemaPackage.CardDtoInput> {
    get { __data.card }
    set { __data.card = newValue }
  }

  public var googlePay: GraphQLNullable<SchemaPackage.GooglePayInput> {
    get { __data.googlePay }
    set { __data.googlePay = newValue }
  }
}
