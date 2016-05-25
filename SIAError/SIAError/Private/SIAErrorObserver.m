//
//  SIAErrorObserver.h
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAErrorObserver.h"
#import "SIAErrorLogger.h"
#import <objc/runtime.h>

@interface SIAErrorObserver ()

@property (weak, nonatomic, nullable) id target;
@property (copy, nonatomic, nonnull) SIAErrorObserverCallback callback;

@end

@implementation SIAErrorObserver

- (nonnull id)initWithTarget:(nonnull id)target AndSelector:(nonnull SEL)selector {
  SIAError_LogAssert(nil != target);
  SIAError_LogAssert(nil != selector);
  
  self = [super init];
  
  if (self) {
    self.target = target;
    
    __weak __typeof__(self) weakSelf = self;
    self.callback = ^BOOL (SIAError* error) {
      BOOL result = FALSE;
      
      __strong __typeof__(self) strongSelf = weakSelf;
      if (nil != strongSelf) {
        
        __strong __typeof__(self.target) strongTarget = strongSelf.target;
        if (nil != strongTarget && [strongTarget respondsToSelector:selector]) {
          
          NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:selector]];
          if (nil != invocation) {
            [invocation setSelector:selector];
            [invocation setTarget:strongTarget];
            [invocation setArgument:&error atIndex:2];
            [invocation invoke];
            
            [invocation getReturnValue:&result];
          }
        }
      }
      
      return result;
    };
  }
  
  return self;
}

- (nonnull id)initWithTarget:(nonnull id)target AndCallback:(nonnull SIAErrorObserverCallback)callback {
  SIAError_LogAssert(nil != target);
  SIAError_LogAssert(nil != callback);
  
  self = [super init];
  
  if (self) {
    self.target = target;
    self.callback = callback;
  }
  
  return self;
}

- (BOOL)notify:(nonnull SIAError*)error {
  SIAError_LogAssert(nil != error);
  
  return self.callback(error);
}

@end

//LifeTime
static char sSIAErrorSubscriberAssociationKey = 0;

@implementation SIAErrorObserver (LifeTime)

- (void)retainToTarget {
  NSMutableSet<SIAErrorObserver*>* associations = [self associations];
  [associations addObject:self];
  
  [self setAssociations:associations];
  
}
- (void)releaseFromTarget {
  NSMutableSet<SIAErrorObserver*>* associations = [self associations];
  [associations removeObject:self];
  [self setAssociations:associations];
}

//Private
- (void)setAssociations:(nonnull NSMutableSet<SIAErrorObserver*>*)associations {
  __strong __typeof__(self.target) strongTarget = self.target;
  if (nil == strongTarget) {
    SIAError_LogError(@"Can't find target for set association");
    return;
  }
  
  objc_setAssociatedObject(strongTarget, &sSIAErrorSubscriberAssociationKey, associations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nonnull NSMutableSet<SIAErrorObserver*>*)associations {
  __strong __typeof__(self.target) strongTarget = self.target;
  
  if (nil == strongTarget) {
    SIAError_LogError(@"Can't find target for get association");
    return [NSMutableSet set];
  }
  
  return objc_getAssociatedObject(strongTarget, &sSIAErrorSubscriberAssociationKey) ?: [NSMutableSet set];
}

@end

