//
//  SIAErrorCollection.m
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAErrorCollection.h"
#import "SIAErrorCodes.h"
#import "SIAErrorLogger.h"

@interface SIAErrorCollection ()

@property (nonatomic, strong, nonnull) NSMutableSet<SIAError*>* errorSet;

@end

@implementation SIAErrorCollection

- (id)init {
  self = [super init];
  
  if (self) {
    self.errorSet = [NSMutableSet set];
  }

  return self;
}

- (void)addErrorToSet:(nonnull SIAError*)error {
  SIAError_LogAssert(nil != error);
  
  @synchronized (self.errorSet) {
    [self.errorSet addObject:error];
  }
}

- (nonnull SIAError*)addError:(nonnull SIAError*)error {
  SIAError_LogAssert(nil != error);
  
  [self addErrorToSet:error];
  SIAError_LogDebug(@"Added %@ to collection.", error);
  
  return error;
}

- (nonnull SIAError*)addErrorByCode:(nonnull SIAErrorCode* const)code {
  SIAError_LogAssert(nil != code);
  return [self addError:[SIAError createByCode:code]];
}

- (nonnull SIAError*)addErrorByCode:(nonnull SIAErrorCode* const)code WithInfo:(nullable NSDictionary*)info {
  SIAError_LogAssert(nil != code);
  return [self addError:[SIAError createByCode:code WithInfo:info]];
}

- (nullable SIAError*)addErrorByCode:(nonnull SIAErrorCode* const)code UseNSError:(nullable NSError*)error {
  SIAError_LogAssert(nil != code);
  SIAError* siaError = [SIAError createByCode:code UseNSError:error];
  if (nil == siaError) {
    return nil;
  }
  return [self addError:siaError];
}

- (nonnull NSArray<SIAError*>*)addErrors:(nonnull SIAErrorCollection*)errorCollection {
  SIAError_LogAssert(nil != errorCollection);
  
  NSArray<SIAError*>* errorArr = [errorCollection errors];
  
  for (SIAError* error in errorArr) {
    [self addErrorToSet:error];
  }
  
  SIAError_LogDebug(@"Added errors from %@ to %@.", errorCollection, self);
  return errorArr;
}


- (BOOL)empty {
  @synchronized (self.errorSet) {
    return (0 == self.errorSet.count);
  }
}

- (BOOL)has:(nonnull SIAError*)error {
  @synchronized (self.errorSet) {
    return [self.errorSet containsObject:error];
  }
}

- (nonnull NSArray<SIAError*>*)errors {
  @synchronized (self.errorSet) {
    return [self.errorSet allObjects];
  }
}

- (void)clean {
  @synchronized (self.errorSet) {
    [self.errorSet removeAllObjects];
  }
}

- (NSString*)description {
  NSMutableString* res = [NSMutableString string];

  [res appendString:@"<SIAErrorCollection> {"];
  for (SIAError* error in [self errors]) {
    [res appendString:[NSString stringWithFormat:@"%@ ", error]];
  }
  [res appendString:@"}"];

  return res;
}

- (NSString*)debugDescription {
  return [self description];
}

@end

