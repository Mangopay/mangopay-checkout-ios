// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CardDtoInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    number: GraphQLNullable<String> = nil,
    expMonth: Int,
    expYear: Int,
    cvc: GraphQLNullable<String> = nil,
    name: GraphQLNullable<String> = nil,
    address: GraphQLNullable<SchemaPackage.AddressDtoInput> = nil
  ) {
    __data = InputDict([
      "number": number,
      "expMonth": expMonth,
      "expYear": expYear,
      "cvc": cvc,
      "name": name,
      "address": address
    ])
  }

  public var number: GraphQLNullable<String> {
    get { __data.number }
    set { __data.number = newValue }
  }

  public var expMonth: Int {
    get { __data.expMonth }
    set { __data.expMonth = newValue }
  }

  public var expYear: Int {
    get { __data.expYear }
    set { __data.expYear = newValue }
  }

  public var cvc: GraphQLNullable<String> {
    get { __data.cvc }
    set { __data.cvc = newValue }
  }

  public var name: GraphQLNullable<String> {
    get { __data.name }
    set { __data.name = newValue }
  }

  public var address: GraphQLNullable<SchemaPackage.AddressDtoInput> {
    get { __data.address }
    set { __data.address = newValue }
  }
}
