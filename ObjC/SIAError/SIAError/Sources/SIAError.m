//
//  SIAError.m
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAError.h"
#import "SIAErrorLogger.h"

@interface SIAError ()

@property (strong, nonatomic, nonnull) SIAErrorCode* const code;
@property (copy, nonatomic, nullable) NSDictionary* info;

@end

@implementation SIAError

+ (nonnull SIAError*)createByCode:(nonnull SIAErrorCode* const)code {
  return [[SIAError alloc] initByCode:code WithInfo:nil];
}

+ (nonnull SIAError*)createByCode:(nonnull SIAErrorCode* const)code WithInfo:(nullable NSDictionary*)info {
  return [[SIAError alloc] initByCode:code WithInfo:info];
}

+ (nullable SIAError*)createByCode:(nonnull SIAErrorCode* const)code UseNSError:(nullable NSError*)error {
  return [[SIAError alloc] initByCode:code UseNSError:error];
}

- (nonnull id)initByCode:(nonnull SIAErrorCode* const)code {
  return [self initByCode:code WithInfo:nil];
}

- (nonnull id)initByCode:(nonnull SIAErrorCode* const)code WithInfo:(nullable NSDictionary*)info {
  SIAError_LogAssert(nil != code);
  
  self = [super init];
  
  if (self) {
    self.code = code;
    self.info = info;
  }
  
  return self;
}

- (nullable id)initByCode:(nonnull SIAErrorCode* const)code UseNSError:(nullable NSError*)error {
  SIAError_LogAssert(nil != code);
  if (nil == error) {
    return nil;
  }
  
  return [self initByCode:code WithInfo:@{@"NSError" : error}];
}

- (NSString*)toString {
  return self.code.text;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"<SIAError> {Code:%@}", self.code];
}

- (NSString*)debugDescription {
  return [NSString stringWithFormat:@"<SIAError> {Code:%@, Info:%@}", self.code, self.info];
}

@end
