//
//  SIAErrorThread.m
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAErrorThread.h"

@interface SIAErrorThread ()

@property (nonatomic, strong) SIAErrorCollection* collection;

@end

@implementation SIAErrorThread

static NSString* sLocalThreadStorageKey = @"SIAError_LocalThreadStorage_For_SIAErrorThread";

+ (nonnull SIAError*)addError:(nonnull SIAError*)error {
  return [[self current].collection addError:error];
}

+ (nonnull SIAError*)addErrorByCode:(nonnull SIAErrorCode* const)code {
  return [[self current].collection addErrorByCode:code];
}

+ (nonnull SIAError*)addErrorByCode:(nonnull SIAErrorCode* const)code WithInfo:(nullable NSDictionary*)info {
  return [[self current].collection addErrorByCode:code WithInfo:info];
}

+ (nullable SIAError*)addErrorByCode:(nonnull SIAErrorCode* const)code UseNSError:(nullable NSError*)error {
  return [[self current].collection addErrorByCode:code UseNSError:error];
}

+ (nonnull SIAErrorCollection*)toCollection {
  //Not synchonized because it's works only one thread.
  SIAErrorCollection* currentCollection = [self current].collection;
  SIAErrorCollection* result = [SIAErrorCollection new];
  
  [result addErrors:currentCollection];
  [currentCollection clean];
  
  return result;
}

//Private
+ (SIAErrorThread*)current {
  NSThread* thread = [NSThread currentThread];
  SIAErrorThread* result = [[thread threadDictionary] objectForKey:sLocalThreadStorageKey];
  
  if (nil == result) {
    result = [SIAErrorThread new];
    [[thread threadDictionary] setObject:result forKey:sLocalThreadStorageKey];
  }
  
  return result;
}

- (id)init {
  self = [super init];
  
  if (self) {
    self.collection = [SIAErrorCollection new];
  }
  
  return self;
}

@end