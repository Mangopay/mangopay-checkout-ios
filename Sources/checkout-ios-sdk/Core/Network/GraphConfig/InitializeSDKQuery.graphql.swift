// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import SchemaPackage

public class InitializeSDKQuery: GraphQLQuery {
  public static let operationName: String = "initializeSDK"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query initializeSDK {
        initializeSDK
      }
      """
    ))

  public init() {}

  public struct Data: SchemaPackage.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { SchemaPackage.Objects.Query }
    public static var __selections: [Selection] { [
      .field("initializeSDK", Bool.self),
    ] }

    public var initializeSDK: Bool { __data["initializeSDK"] }
  }
}
