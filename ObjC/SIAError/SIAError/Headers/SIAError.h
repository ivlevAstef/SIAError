//
//  SIAError.h
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAErrorCode.h"

@interface SIAError : NSObject

+ (nonnull SIAError*)createByCode:(nonnull SIAErrorCode* const)code;
+ (nonnull SIAError*)createByCode:(nonnull SIAErrorCode* const)code WithInfo:(nullable NSDictionary*)info;
+ (nullable SIAError*)createByCode:(nonnull SIAErrorCode* const)code UseNSError:(nullable NSError*)error;

- (nonnull id)initByCode:(nonnull SIAErrorCode* const)code;
- (nonnull id)initByCode:(nonnull SIAErrorCode* const)code WithInfo:(nullable NSDictionary*)info;
- (nullable id)initByCode:(nonnull SIAErrorCode* const)code UseNSError:(nullable NSError*)error;
- (nonnull id)init __attribute__((unavailable("Use initByCode:WithInfo:")));

- (nonnull NSString*)toString;

@property (readonly, nonatomic, nonnull) SIAErrorCode* const code;
@property (readonly, nonatomic, nullable) NSDictionary* info;

@end

