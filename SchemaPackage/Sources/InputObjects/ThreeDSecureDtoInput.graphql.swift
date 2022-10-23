// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct ThreeDSecureDtoInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    redirectUrl: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "redirectUrl": redirectUrl
    ])
  }

  public var redirectUrl: GraphQLNullable<String> {
    get { __data.redirectUrl }
    set { __data.redirectUrl = newValue }
  }
}
