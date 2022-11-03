// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import SchemaPackage

public class CreateCustomerMutation: GraphQLMutation {
  public static let operationName: String = "createCustomer"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation createCustomer($data: CustomerInput!) {
        createCustomer(data: $data)
      }
      """
    ))

  public var data: SchemaPackage.CustomerInput

  public init(data: SchemaPackage.CustomerInput) {
    self.data = data
  }

  public var __variables: Variables? { ["data": data] }

  public struct Data: SchemaPackage.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { SchemaPackage.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("createCustomer", String.self, arguments: ["data": .variable("data")]),
    ] }

    public var createCustomer: String { __data["createCustomer"] }
  }
}
