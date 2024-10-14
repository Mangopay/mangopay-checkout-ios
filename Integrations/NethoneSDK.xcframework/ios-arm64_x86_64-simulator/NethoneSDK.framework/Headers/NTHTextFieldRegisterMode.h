#import <Foundation/Foundation.h>
/**
 The `NTHRegisterMode` enum provides constants for the data collecting options for a textField when is registered.

 - `NoneData`: No behavioral and none text data will be collected.
 - `ContentFree`: No text data, only behavioral data will be collected.
 - `AllData`: All behavioral and text data will be collected.
*/
typedef NS_ENUM(NSInteger, NTHRegisterMode) {
	NoneData,
	ContentFree,
	AllData
};
