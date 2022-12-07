// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension CheckoutSchema {
  class GetPaymentQuery: GraphQLQuery {
    public static let operationName: String = "getPayment"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
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

    public var id: ID

    public init(id: ID) {
      self.id = id
    }

    public var __variables: Variables? { ["id": id] }

    public struct Data: CheckoutSchema.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { CheckoutSchema.Objects.Query }
      public static var __selections: [Selection] { [
        .field("getPayment", GetPayment?.self, arguments: ["id": .variable("id")]),
      ] }

      public var getPayment: GetPayment? { __data["getPayment"] }

      /// GetPayment
      ///
      /// Parent Type: `Payment`
      public struct GetPayment: CheckoutSchema.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { CheckoutSchema.Objects.Payment }
        public static var __selections: [Selection] { [
          .field("id", ID.self),
          .field("date", DateTime.self),
          .field("country", String?.self),
          .field("amount", Amount?.self),
          .field("status", GraphQLEnum<PaymentStatus>?.self),
          .field("paymentGateway", PaymentGateway?.self),
          .field("paymentCore", PaymentCore?.self),
          .field("paymentDetails", PaymentDetails?.self),
          .field("paymentTimeline", PaymentTimeline?.self),
          .field("paymentCustomer", PaymentCustomer?.self),
          .field("paymentMethodDetails", PaymentMethodDetails?.self),
          .field("metadata", JSON?.self),
          .field("attachments", [Attachment?]?.self),
        ] }

        public var id: ID { __data["id"] }
        public var date: DateTime { __data["date"] }
        public var country: String? { __data["country"] }
        public var amount: Amount? { __data["amount"] }
        public var status: GraphQLEnum<PaymentStatus>? { __data["status"] }
        public var paymentGateway: PaymentGateway? { __data["paymentGateway"] }
        public var paymentCore: PaymentCore? { __data["paymentCore"] }
        public var paymentDetails: PaymentDetails? { __data["paymentDetails"] }
        public var paymentTimeline: PaymentTimeline? { __data["paymentTimeline"] }
        public var paymentCustomer: PaymentCustomer? { __data["paymentCustomer"] }
        public var paymentMethodDetails: PaymentMethodDetails? { __data["paymentMethodDetails"] }
        public var metadata: JSON? { __data["metadata"] }
        public var attachments: [Attachment?]? { __data["attachments"] }

        /// GetPayment.Amount
        ///
        /// Parent Type: `Amount`
        public struct Amount: CheckoutSchema.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { CheckoutSchema.Objects.Amount }
          public static var __selections: [Selection] { [
            .field("formattedAmount", String.self),
          ] }

          public var formattedAmount: String { __data["formattedAmount"] }
        }

        /// GetPayment.PaymentGateway
        ///
        /// Parent Type: `PaymentGateway`
        public struct PaymentGateway: CheckoutSchema.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentGateway }
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
        public struct PaymentCore: CheckoutSchema.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentCore }
          public static var __selections: [Selection] { [
            .field("paymentMethod", GraphQLEnum<PaymentMethodEnum>?.self),
            .field("outcome", Outcome?.self),
          ] }

          public var paymentMethod: GraphQLEnum<PaymentMethodEnum>? { __data["paymentMethod"] }
          public var outcome: Outcome? { __data["outcome"] }

          /// GetPayment.PaymentCore.Outcome
          ///
          /// Parent Type: `PaymentOutcome`
          public struct Outcome: CheckoutSchema.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentOutcome }
            public static var __selections: [Selection] { [
              .field("networkStatus", String?.self),
              .field("reason", String?.self),
              .field("riskLevel", String?.self),
              .field("riskScore", Long?.self),
              .field("type", GraphQLEnum<PaymentType>?.self),
            ] }

            public var networkStatus: String? { __data["networkStatus"] }
            public var reason: String? { __data["reason"] }
            public var riskLevel: String? { __data["riskLevel"] }
            public var riskScore: Long? { __data["riskScore"] }
            public var type: GraphQLEnum<PaymentType>? { __data["type"] }
          }
        }

        /// GetPayment.PaymentDetails
        ///
        /// Parent Type: `PaymentDetails`
        public struct PaymentDetails: CheckoutSchema.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentDetails }
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
          public struct LocalAmount: CheckoutSchema.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { CheckoutSchema.Objects.Amount }
            public static var __selections: [Selection] { [
              .field("formattedAmount", String.self),
            ] }

            public var formattedAmount: String { __data["formattedAmount"] }
          }

          /// GetPayment.PaymentDetails.Fee
          ///
          /// Parent Type: `Amount`
          public struct Fee: CheckoutSchema.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { CheckoutSchema.Objects.Amount }
            public static var __selections: [Selection] { [
              .field("formattedAmount", String.self),
            ] }

            public var formattedAmount: String { __data["formattedAmount"] }
          }

          /// GetPayment.PaymentDetails.Tax
          ///
          /// Parent Type: `Amount`
          public struct Tax: CheckoutSchema.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { CheckoutSchema.Objects.Amount }
            public static var __selections: [Selection] { [
              .field("formattedAmount", String.self),
            ] }

            public var formattedAmount: String { __data["formattedAmount"] }
          }

          /// GetPayment.PaymentDetails.ProcessingFee
          ///
          /// Parent Type: `Amount`
          public struct ProcessingFee: CheckoutSchema.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { CheckoutSchema.Objects.Amount }
            public static var __selections: [Selection] { [
              .field("formattedAmount", String.self),
            ] }

            public var formattedAmount: String { __data["formattedAmount"] }
          }

          /// GetPayment.PaymentDetails.Net
          ///
          /// Parent Type: `Amount`
          public struct Net: CheckoutSchema.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { CheckoutSchema.Objects.Amount }
            public static var __selections: [Selection] { [
              .field("formattedAmount", String.self),
            ] }

            public var formattedAmount: String { __data["formattedAmount"] }
          }
        }

        /// GetPayment.PaymentTimeline
        ///
        /// Parent Type: `PaymentTimeline`
        public struct PaymentTimeline: CheckoutSchema.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentTimeline }
          public static var __selections: [Selection] { [
            .field("overview", [Overview?]?.self),
            .field("flows", [Flow?]?.self),
          ] }

          public var overview: [Overview?]? { __data["overview"] }
          public var flows: [Flow?]? { __data["flows"] }

          /// GetPayment.PaymentTimeline.Overview
          ///
          /// Parent Type: `PaymentTimelineEvent`
          public struct Overview: CheckoutSchema.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentTimelineEvent }
            public static var __selections: [Selection] { [
              .field("title", String?.self),
              .field("time", DateTime?.self),
              .field("message", String?.self),
            ] }

            public var title: String? { __data["title"] }
            public var time: DateTime? { __data["time"] }
            public var message: String? { __data["message"] }
          }

          /// GetPayment.PaymentTimeline.Flow
          ///
          /// Parent Type: `FlowSummary`
          public struct Flow: CheckoutSchema.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { CheckoutSchema.Objects.FlowSummary }
            public static var __selections: [Selection] { [
              .field("name", String?.self),
              .field("date", DateTime?.self),
              .field("flowId", String?.self),
              .field("flowInstanceId", String?.self),
            ] }

            public var name: String? { __data["name"] }
            public var date: DateTime? { __data["date"] }
            public var flowId: String? { __data["flowId"] }
            public var flowInstanceId: String? { __data["flowInstanceId"] }
          }
        }

        /// GetPayment.PaymentCustomer
        ///
        /// Parent Type: `PaymentCustomer`
        public struct PaymentCustomer: CheckoutSchema.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentCustomer }
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
        public struct PaymentMethodDetails: CheckoutSchema.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { CheckoutSchema.Objects.PaymentMethodDetails }
          public static var __selections: [Selection] { [
            .field("id", String?.self),
            .field("number", String?.self),
            .field("expires", String?.self),
            .field("fingerprint", String?.self),
            .field("paymentMethod", GraphQLEnum<PaymentMethodEnum>?.self),
          ] }

          public var id: String? { __data["id"] }
          public var number: String? { __data["number"] }
          public var expires: String? { __data["expires"] }
          public var fingerprint: String? { __data["fingerprint"] }
          public var paymentMethod: GraphQLEnum<PaymentMethodEnum>? { __data["paymentMethod"] }
        }

        /// GetPayment.Attachment
        ///
        /// Parent Type: `Attachment`
        public struct Attachment: CheckoutSchema.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { CheckoutSchema.Objects.Attachment }
          public static var __selections: [Selection] { [
            .field("fileName", String?.self),
          ] }

          public var fileName: String? { __data["fileName"] }
        }
      }
    }
  }

}