#import <Foundation/Foundation.h>

/**
 * Error userInfo key leading to attempt reference if occur
 */
extern NSString * const kNTHNethoneAttemptReference;

/**
 * Nethone error domain
 */
extern NSErrorDomain const NTHApiErrorDomain;

/**
 * NTHApiErrorCode
 * Error codes that can appear immediately during the NTHNetone API call verification.
 */
typedef NS_ERROR_ENUM(NTHApiErrorDomain, NTHApiErrorCode) {
	/**
	 * Begin called while merchant number is not set.
	 *
	 * Merchant number should be set only once using function +setMerchantNumber: before starting
	 * profiling i.e. calling +beginAttemptWithConfiguration:error:
	 * Without setting merchant number, profiling cannot be started, so NO data will be collected.
	 */
	kNTHApiErrorMerchantNumberNotSet = -1,

	/**
	 * Begin called when another attempt is ongoing.
	 *
	 * Only one profiling attempt is possible at the time.
	 * It is possible that the previous profiling has not yet completed finalization
	 * (after calling the +finalizeAttemptWithCompletion:error:), in this case, you should wait for it to finish
	 * before starting the next profiling.
	 * To force the immediate termination of the profiling, you can call +cancelAttemptWithError: however,
	 * this may result in the collection of insufficient data.
	 *
	 * Another possibility where the error occurred is the user returning to the initial screen and invoking
	 * the begin function unintentionally, in this case, if new profiling is not necessary, ignore the error,
	 * continue the profiling session and use current attempt reference.
	 *
	 * Optimal assumption you should be aiming to is 1 profiling per 1 inquiry.
	 */
	kNTHApiErrorAnotherAttemptOngoing = -2,

	/**
	 * Finalize or send custom data called when the attempt is already completed or canceled.
	 *
	 * The last profiling has already been completed. Currently, no profiling is in progress,
	 * it is not possible to finalize it or send additional data as part of it.
	 * The AttemptReference of the last profiling can be found in error.userInfo under
	 * the key kNTHNethoneAttemptReference.
	 */
	kNTHApiErrorFinalizingAlreadyEndedAttempt = -5,

	/**
	 * Cancel called when the attempt is already completed or canceled.
	 *
	 * The last profiling has already been completed. Currently, no profiling is in progress,
	 * it is not possible to cancel it.
	 */
	kNTHApiErrorCancelingAlreadyEndedAttempt = -15,

	/**
	 * Finalize or send custom data called when profiling is just being finalized.
	 *
	 * Profiling is now being finalized. It cannot be finalized again.
	 * Probably +finalizeAttemptWithCompletion:error: was called twice before completion handler was
	 * executed or called directly in completion handler.
	 *
	 * Custom data cannot be sent during finalization or after profiling is completed.
	 */
	kNTHApiErrorAttemptDuringFinalization = -13,

	/**
	 * Finalize, cancel or send custom data called without begin called before
	 *
	 * Currently, no profiling has been started, it is not possible to finalize, cancel or send additional data.
	 * You must first start profiling by calling +beginAttemptWithConfiguration:error:
	 */
	kNTHApiErrorAttemptNotInitiated = -6,

	/**
	 * Send custom data called with structure that cannot be parsed properly.
	 */
	kNTHApiErrorInvalidCustomData = -14,
};
