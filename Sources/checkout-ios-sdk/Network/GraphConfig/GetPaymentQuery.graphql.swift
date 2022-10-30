// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import SchemaPackage

public class GetPaymentQuery: GraphQLQuery {
  public static let operationName: String = "getPayment"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query getPayment($id: ID!) {
        getPayment(id: $id) {
          __typename
          id
          date
          country
          amount {
            __typename
            formattedAmount
          }
          status
          paymentGateway {
            __typename
            name
            logo
          }
          paymentCore {
            __typename
            paymentMethod
            outcome {
              __typename
              networkStatus
              reason
              riskLevel
              riskScore
              type
            }
          }
          paymentDetails {
            __typename
            statementDescriptor
            localCurrency
            localAmount {
              __typename
              formattedAmount
            }
            exchangeRate
            fee {
              __typename
              formattedAmount
            }
            tax {
              __typename
              formattedAmount
            }
            processingFee {
              __typename
              formattedAmount
            }
            net {
              __typename
              formattedAmount
            }
            description
          }
          paymentTimeline {
            __typename
            overview {
              __typename
              title
              time
              message
            }
            flows {
              __typename
              name
              date
              flowId
              flowInstanceId
            }
          }
          paymentCustomer {
            __typename
            id
            email
          }
          paymentMethodDetails {
            __typename
            id
            number
            expires
            fingerprint
            paymentMethod
          }
          metadata
          attachments {
            __typename
            fileName
          }
        }
      }
      """
    ))

  public var id: SchemaPackage.ID

  public init(id: SchemaPackage.ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: SchemaPackage.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { SchemaPackage.Objects.Query }
    public static var __selections: [Selection] { [
      .field("getPayment", GetPayment?.self, arguments: ["id": .variable("id")]),
    ] }

    public var getPayment: GetPayment? { __data["getPayment"] }

    /// GetPayment
    ///
    /// Parent Type: `Payment`
    public struct GetPayment: SchemaPackage.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { SchemaPackage.Objects.Payment }
      public static var __selections: [Selection] { [
        .field("id", SchemaPackage.ID.self),
        .field("date", SchemaPackage.DateTime.self),
        .field("country", String?.self),
        .field("amount", Amount?.self),
        .field("status", GraphQLEnum<SchemaPackage.PaymentStatus>?.self),
        .field("paymentGateway", PaymentGateway?.self),
        .field("paymentCore", PaymentCore?.self),
        .field("paymentDetails", PaymentDetails?.self),
        .field("paymentTimeline", PaymentTimeline?.self),
        .field("paymentCustomer", PaymentCustomer?.self),
        .field("paymentMethodDetails", PaymentMethodDetails?.self),
        .field("metadata", SchemaPackage.JSON?.self),
        .field("attachments", [Attachment?]?.self),
      ] }

      public var id: SchemaPackage.ID { __data["id"] }
      public var date: SchemaPackage.DateTime { __data["date"] }
      public var country: String? { __data["country"] }
      public var amount: Amount? { __data["amount"] }
      public var status: GraphQLEnum<SchemaPackage.PaymentStatus>? { __data["status"] }
      public var paymentGateway: PaymentGateway? { __data["paymentGateway"] }
      public var paymentCore: PaymentCore? { __data["paymentCore"] }
      public var paymentDetails: PaymentDetails? { __data["paymentDetails"] }
      public var paymentTimeline: PaymentTimeline? { __data["paymentTimeline"] }
      public var paymentCustomer: PaymentCustomer? { __data["paymentCustomer"] }
      public var paymentMethodDetails: PaymentMethodDetails? { __data["paymentMethodDetails"] }
      public var metadata: SchemaPackage.JSON? { __data["metadata"] }
      public var attachments: [Attachment?]? { __data["attachments"] }

      /// GetPayment.Amount
      ///
      /// Parent Type: `Amount`
      public struct Amount: SchemaPackage.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { SchemaPackage.Objects.Amount }
        public static var __selections: [Selection] { [
          .field("formattedAmount", String.self),
        ] }

        public var formattedAmount: String { __data["formattedAmount"] }
      }

      /// GetPayment.PaymentGateway
      ///
      /// Parent Type: `PaymentGateway`
      public struct PaymentGateway: SchemaPackage.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { SchemaPackage.Objects.PaymentGateway }
        public static var __selections: [Selection] { [
          .field("name", String?.self),
          .field("logo", String?.self),
        ] }

        public var name: String? { __data["name"] }
        public var logo: String? { __data["logo"] }
      }

      /// GetPayment.PaymentCore
      ///
      /// Parent Type: `PaymentCore`
      public struct PaymentCore: SchemaPackage.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { SchemaPackage.Objects.PaymentCore }
        public static var __selections: [Selection] { [
          .field("paymentMethod", GraphQLEnum<SchemaPackage.PaymentMethodEnum>?.self),
          .field("outcome", Outcome?.self),
        ] }

        public var paymentMethod: GraphQLEnum<SchemaPackage.PaymentMethodEnum>? { __data["paymentMethod"] }
        public var outcome: Outcome? { __data["outcome"] }

        /// GetPayment.PaymentCore.Outcome
        ///
        /// Parent Type: `PaymentOutcome`
        public struct Outcome: SchemaPackage.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { SchemaPackage.Objects.PaymentOutcome }
          public static var __selections: [Selection] { [
            .field("networkStatus", String?.self),
            .field("reason", String?.self),
            .field("riskLevel", String?.self),
            .field("riskScore", SchemaPackage.Long?.self),
            .field("type", GraphQLEnum<SchemaPackage.PaymentType>?.self),
          ] }

          public var networkStatus: String? { __data["networkStatus"] }
          public var reason: String? { __data["reason"] }
          public var riskLevel: String? { __data["riskLevel"] }
          public var riskScore: SchemaPackage.Long? { __data["riskScore"] }
          public var type: GraphQLEnum<SchemaPackage.PaymentType>? { __data["type"] }
        }
      }

      /// GetPayment.PaymentDetails
      ///
      /// Parent Type: `PaymentDetails`
      public struct PaymentDetails: SchemaPackage.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { SchemaPackage.Objects.PaymentDetails }
        public static var __selections: [Selection] { [
          .field("statementDescriptor", String?.self),
          .field("localCurrency", String?.self),
          .field("localAmount", LocalAmount?.self),
          .field("exchangeRate", String?.self),
          .field("fee", Fee?.self),
          .field("tax", Tax?.self),
          .field("processingFee", ProcessingFee?.self),
          .field("net", Net?.self),
          .field("description", String?.self),
        ] }

        public var statementDescriptor: String? { __data["statementDescriptor"] }
        public var localCurrency: String? { __data["localCurrency"] }
        public var localAmount: LocalAmount? { __data["localAmount"] }
        public var exchangeRate: String? { __data["exchangeRate"] }
        public var fee: Fee? { __data["fee"] }
        public var tax: Tax? { __data["tax"] }
        public var processingFee: ProcessingFee? { __data["processingFee"] }
        public var net: Net? { __data["net"] }
        public var description: String? { __data["description"] }

        /// GetPayment.PaymentDetails.LocalAmount
        ///
        /// Parent Type: `Amount`
        public struct LocalAmount: SchemaPackage.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { SchemaPackage.Objects.Amount }
          public static var __selections: [Selection] { [
            .field("formattedAmount", String.self),
          ] }

          public var formattedAmount: String { __data["formattedAmount"] }
        }

        /// GetPayment.PaymentDetails.Fee
        ///
        /// Parent Type: `Amount`
        public struct Fee: SchemaPackage.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { SchemaPackage.Objects.Amount }
          public static var __selections: [Selection] { [
            .field("formattedAmount", String.self),
          ] }

          public var formattedAmount: String { __data["formattedAmount"] }
        }

        /// GetPayment.PaymentDetails.Tax
        ///
        /// Parent Type: `Amount`
        public struct Tax: SchemaPackage.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { SchemaPackage.Objects.Amount }
          public static var __selections: [Selection] { [
            .field("formattedAmount", String.self),
          ] }

          public var formattedAmount: String { __data["formattedAmount"] }
        }

        /// GetPayment.PaymentDetails.ProcessingFee
        ///
        /// Parent Type: `Amount`
        public struct ProcessingFee: SchemaPackage.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { SchemaPackage.Objects.Amount }
          public static var __selections: [Selection] { [
            .field("formattedAmount", String.self),
          ] }

          public var formattedAmount: String { __data["formattedAmount"] }
        }

        /// GetPayment.PaymentDetails.Net
        ///
        /// Parent Type: `Amount`
        public struct Net: SchemaPackage.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { SchemaPackage.Objects.Amount }
          public static var __selections: [Selection] { [
            .field("formattedAmount", String.self),
          ] }

          public var formattedAmount: String { __data["formattedAmount"] }
        }
      }

      /// GetPayment.PaymentTimeline
      ///
      /// Parent Type: `PaymentTimeline`
      public struct PaymentTimeline: SchemaPackage.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { SchemaPackage.Objects.PaymentTimeline }
        public static var __selections: [Selection] { [
          .field("overview", [Overview?]?.self),
          .field("flows", [Flow?]?.self),
        ] }

        public var overview: [Overview?]? { __data["overview"] }
        public var flows: [Flow?]? { __data["flows"] }

        /// GetPayment.PaymentTimeline.Overview
        ///
        /// Parent Type: `PaymentTimelineEvent`
        public struct Overview: SchemaPackage.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { SchemaPackage.Objects.PaymentTimelineEvent }
          public static var __selections: [Selection] { [
            .field("title", String?.self),
            .field("time", SchemaPackage.DateTime?.self),
            .field("message", String?.self),
          ] }

          public var title: String? { __data["title"] }
          public var time: SchemaPackage.DateTime? { __data["time"] }
          public var message: String? { __data["message"] }
        }

        /// GetPayment.PaymentTimeline.Flow
        ///
        /// Parent Type: `FlowSummary`
        public struct Flow: SchemaPackage.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { SchemaPackage.Objects.FlowSummary }
          public static var __selections: [Selection] { [
            .field("name", String?.self),
            .field("date", SchemaPackage.DateTime?.self),
            .field("flowId", String?.self),
            .field("flowInstanceId", String?.self),
          ] }

          public var name: String? { __data["name"] }
          public var date: SchemaPackage.DateTime? { __data["date"] }
          public var flowId: String? { __data["flowId"] }
          public var flowInstanceId: String? { __data["flowInstanceId"] }
        }
      }

      /// GetPayment.PaymentCustomer
      ///
      /// Parent Type: `PaymentCustomer`
      public struct PaymentCustomer: SchemaPackage.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { SchemaPackage.Objects.PaymentCustomer }
        public static var __selections: [Selection] { [
          .field("id", String?.self),
          .field("email", String?.self),
        ] }

        public var id: String? { __data["id"] }
        public var email: String? { __data["email"] }
      }

      /// GetPayment.PaymentMethodDetails
      ///
      /// Parent Type: `PaymentMethodDetails`
      public struct PaymentMethodDetails: SchemaPackage.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { SchemaPackage.Objects.PaymentMethodDetails }
        public static var __selections: [Selection] { [
          .field("id", String?.self),
          .field("number", String?.self),
          .field("expires", String?.self),
          .field("fingerprint", String?.self),
          .field("paymentMethod", GraphQLEnum<SchemaPackage.PaymentMethodEnum>?.self),
        ] }

        public var id: String? { __data["id"] }
        public var number: String? { __data["number"] }
        public var expires: String? { __data["expires"] }
        public var fingerprint: String? { __data["fingerprint"] }
        public var paymentMethod: GraphQLEnum<SchemaPackage.PaymentMethodEnum>? { __data["paymentMethod"] }
      }

      /// GetPayment.Attachment
      ///
      /// Parent Type: `Attachment`
      public struct Attachment: SchemaPackage.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { SchemaPackage.Objects.Attachment }
        public static var __selections: [Selection] { [
          .field("fileName", String?.self),
        ] }

        public var fileName: String? { __data["fileName"] }
      }
    }
  }
}
