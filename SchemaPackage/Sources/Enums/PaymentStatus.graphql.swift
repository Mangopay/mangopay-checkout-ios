// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public enum PaymentStatus: String, EnumType {
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
}
