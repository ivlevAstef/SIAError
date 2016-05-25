//
//  SIAErrorCode.m
//  SIAError
//
//  Created by Alexander Ivlev on 25/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAErrorCode.h"
#import "SIAErrorLogger.h"
#import "libkern/OSAtomic.h"

@interface SIAErrorCode ()

@property (assign, nonatomic) NSInteger priority;
@property (copy, nonatomic, nonnull) NSString* text;
@property (strong, nonatomic, nonnull) SIAErrorCodeIdentifier identifier;

@end

@implementation SIAErrorCode

static volatile int64_t sIdentifierCounter = 0;

+ (SIAErrorCode*)createWithPriority:(NSInteger)priority AndText:(nonnull NSString*)text {
  return [[SIAErrorCode alloc] initWithPriority:priority AndText:text];
}

- (id)initWithPriority:(NSInteger)priority AndText:(nonnull NSString*)text {
  SIAError_LogAssert(nil != text);
  
  self = [super init];
  
  if (self) {
    self.priority = priority;
    self.text = text;
    
    self.identifier = @(OSAtomicIncrement64(&sIdentifierCounter));
  }
  
  return self;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"<SIAErrorCode> {Priority:%ld, Description:%@}", (long)self.priority, self.text];
}

- (NSString*)debugDescription {
  return [self description];
}

@end