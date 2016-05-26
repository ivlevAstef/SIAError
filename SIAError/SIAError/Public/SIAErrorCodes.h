//
//  SIAErrorCodes.h
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAErrorCode.h"

#define SIA_ERROR_CODES_INTERFACE_METHOD(NAME, PRIORITY, TEXT) \
  + (SIAErrorCode* const)NAME;

#define SIA_ERROR_CODES_IMPLEMENTED_METHOD(NAME, PRIORITY, TEXT)       \
  + (SIAErrorCode* const)NAME {                                        \
    static dispatch_once_t onceToken;                                  \
    static SIAErrorCode* error = nil;                                  \
    dispatch_once(&onceToken, ^{                                       \
      error = [SIAErrorCode createWithPriority:PRIORITY AndText:TEXT]; \
    });                                                                \
    return error;                                                      \
  }


#define SIA_ERROR_CODES_INTERFACE(MODULE, ERRORS) \
@interface SIAErrorCodes(MODULE)                  \
  ERRORS(SIA_ERROR_CODES_INTERFACE_METHOD)        \
@end

#define SIA_ERROR_CODES_IMPLEMENTATION(MODULE, ERRORS) \
@implementation SIAErrorCodes(MODULE)                  \
  ERRORS(SIA_ERROR_CODES_IMPLEMENTED_METHOD)           \
@end


@interface SIAErrorCodes : NSObject

+ (NSArray<SIAErrorCode*>*)Any;
+ (NSArray<SIAErrorCode*>*)AnyWithout:(NSArray<SIAErrorCode*>*)codes;

@end


/* Example:
 
// Your header file
 
#import <SIAError/SIAErrors.h>
 
#define YOUR_ERRORS_DEFINE(X)                  \
 X(Undefined, 100, @"Undefined Text")          \
 X(YourError1, 200, @"YourError1 description") \
 X(YourError2, 250, @"YourError2 description") \
 X(YourError3, 150, @"YourError3 description")

SIA_ERROR_CODES_INTERFACE(YOUR_ERROR_MODULE, YOUR_ERRORS_DEFINE)
 
// Your implemented file
 
#import "your header file.h"

SIA_ERROR_CODES_IMPLEMENTATION(YOUR_ERROR_MODULE, YOUR_ERRORS_DEFINE)
 
// Use
 
[SIAErrorCodes Undefined].prioirity
[SIAErrorCodes YourError2].text
 
*/


