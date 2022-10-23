// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import SchemaPackage

public class AuthorizePaymentMutation: GraphQLMutation {
  public static let operationName: String = "authorizePayment"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation authorizePayment($authorisePayment: AuthorisedPaymentInput!) {
        authorizePayment(authorisePayment: $authorisePayment) {
          __typename
          id
          status
        }
      }
      """
    ))

  public var authorisePayment: SchemaPackage.AuthorisedPaymentInput

  public init(authorisePayment: SchemaPackage.AuthorisedPaymentInput) {
    self.authorisePayment = authorisePayment
  }

  public var __variables: Variables? { ["authorisePayment": authorisePayment] }

  public struct Data: SchemaPackage.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { SchemaPackage.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("authorizePayment", AuthorizePayment?.self, arguments: ["authorisePayment": .variable("authorisePayment")]),
    ] }

    public var authorizePayment: AuthorizePayment? { __data["authorizePayment"] }

    /// AuthorizePayment
    ///
    /// Parent Type: `Payment`
    public struct AuthorizePayment: SchemaPackage.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { SchemaPackage.Objects.Payment }
      public static var __selections: [Selection] { [
        .field("id", SchemaPackage.ID.self),
        .field("status", GraphQLEnum<SchemaPackage.PaymentStatus>?.self),
      ] }

      public var id: SchemaPackage.ID { __data["id"] }
      public var status: GraphQLEnum<SchemaPackage.PaymentStatus>? { __data["status"] }
    }
  }
}
