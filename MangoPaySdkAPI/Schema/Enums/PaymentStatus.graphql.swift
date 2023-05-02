// @generated
// This file was automatically generated and should not be edited.

#if !COCOAPODS
import ApolloAPI
#else
import Apollo
#endif

public extension CheckoutSchema {
  enum PaymentStatus: String, EnumType {
    case draft = "DRAFT"
    case active = "ACTIVE"
    case inactive = "INACTIVE"
    case authorised = "AUTHORISED"
    case succeeded = "SUCCEEDED"
    case refunded = "REFUNDED"
    case partialRefunded = "PARTIAL_REFUNDED"
    case cancelled = "CANCELLED"
    case failed = "FAILED"
    case declined = "DECLINED"
    case disputed = "DISPUTED"
    case removed = "REMOVED"
    case needs3DSecure = "NEEDS_3D_SECURE"
    case needsApmAuthorization = "NEEDS_APM_AUTHORIZATION"
    case gatewayHold = "GATEWAY_HOLD"
    case refundPending = "REFUND_PENDING"
    case refundFailed = "REFUND_FAILED"
    case noAnswerFromPsp = "NO_ANSWER_FROM_PSP"
  }

}
