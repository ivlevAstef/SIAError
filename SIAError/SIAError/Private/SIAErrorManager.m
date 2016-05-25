//
//  SIAErrorManager.m
//  SIAError
//
//  Created by Alexander Ivlev on 25/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAErrorManager.h"
#import "SIAErrorObserver.h"
#import "SIAErrorLogger.h"

@interface SIAErrorManager ()

@property (strong, nonatomic, nonnull) NSMutableDictionary<SIAErrorCodeIdentifier, NSPointerArray/*<SIAErrorObserver*>*/*>* observersMap;

@end

@implementation SIAErrorManager

+ (nonnull id<SIAErrorObserverIdentifier>)subscibeToOne:(nonnull SIAErrorCode* const)code Target:(nonnull id)target Selector:(nonnull SEL)selector {
  SIAError_LogAssert(nil != code);
  SIAError_LogAssert(nil != target);
  SIAError_LogAssert(nil != selector);
  
  SIAErrorObserver* observer = [[SIAErrorObserver alloc] initWithTarget:target AndSelector:selector];
  [[self sharedErrorManager] addObserver:observer ForErrorCode:code];
  return observer;
}

+ (nonnull id<SIAErrorObserverIdentifier>)subscibeToOne:(nonnull SIAErrorCode* const)code Target:(nonnull id)target Callback:(nonnull SIAErrorObserverCallback)callback {
  SIAError_LogAssert(nil != code);
  SIAError_LogAssert(nil != target);
  SIAError_LogAssert(nil != callback);
 
  SIAErrorObserver* observer = [[SIAErrorObserver alloc] initWithTarget:target AndCallback:callback];
  [[self sharedErrorManager] addObserver:observer ForErrorCode:code];
  return observer;
}

+ (nonnull id<SIAErrorObserverIdentifier>)subscibeToArray:(nonnull NSArray<SIAErrorCode*>*)codes Target:(nonnull id)target Selector:(nonnull SEL)selector {
  SIAError_LogAssert(nil != codes);
  SIAError_LogAssert(nil != target);
  SIAError_LogAssert(nil != selector);
  
  SIAErrorObserver* observer = [[SIAErrorObserver alloc] initWithTarget:target AndSelector:selector];
  for (SIAErrorCode* const code in codes) {
    [[self sharedErrorManager] addObserver:observer ForErrorCode:code];
  }
  
  return observer;
}

+ (nonnull id<SIAErrorObserverIdentifier>)subscibeToArray:(nonnull NSArray<SIAErrorCode*>*)codes Target:(nonnull id)target Callback:(nonnull SIAErrorObserverCallback)callback {
  SIAError_LogAssert(nil != codes);
  SIAError_LogAssert(nil != target);
  SIAError_LogAssert(nil != callback);
  
  SIAErrorObserver* observer = [[SIAErrorObserver alloc] initWithTarget:target AndCallback:callback];
  
  for (SIAErrorCode* const code in codes) {
    [[self sharedErrorManager] addObserver:observer ForErrorCode:code];
  }
  
  return observer;
}

+ (void)unsubscribe:(nonnull id<SIAErrorObserverIdentifier>)observer {
  SIAError_LogAssert([observer isKindOfClass:[SIAErrorObserver class]]);
  
  [[self sharedErrorManager] removeObserver:(SIAErrorObserver*)observer];
}

+ (void)notify:(nonnull SIAError*)error {
  SIAError_LogAssert(nil != error);
  
  NSArray* observersArr = nil;
  @synchronized ([self sharedErrorManager].observersMap) {
    NSPointerArray* observers = [[self sharedErrorManager].observersMap objectForKey:error.code.identifier];
    if (nil == observers) {
      return;
    }
    
    observersArr = [observers allObjects];
  }
  
  
  for (SIAErrorObserver* observer in observersArr) {
    if([observer notify:error]) {
      break;
    }
  }
}

+ (void)notifyAll:(nonnull SIAErrorCollection*)collection {
  SIAError_LogAssert(nil != collection);
  
  for (SIAError* error in [collection errors]) {
    [self notify:error];
  }
}

+ (void)notifyMaxPriority:(nonnull SIAErrorCollection*)collection {
  SIAError_LogAssert(nil != collection);
  
  SIAError* maxPriorityError = nil;
  
  for (SIAError* error in [collection errors]) {
    if (nil == maxPriorityError || maxPriorityError.code.priority < error.code.priority) {
      maxPriorityError = error;
    }
  }
  
  if (nil != maxPriorityError) {
    [self notify:maxPriorityError];
  }
}

//Private
+ (SIAErrorManager*)sharedErrorManager {
  static dispatch_once_t onceToken;
  static SIAErrorManager* errorManager = nil;
  dispatch_once(&onceToken, ^{
    errorManager = [[SIAErrorManager alloc] init];
  });
  return errorManager;
}

- (id)init {
  self = [super init];
  if (self) {
    self.observersMap = [NSMutableDictionary dictionary];
  }
  
  return self;
}

- (void)addObserver:(nonnull SIAErrorObserver*)observer ForErrorCode:(nonnull SIAErrorCode* const)code {
  SIAError_LogAssert(nil != observer);
  SIAError_LogAssert(nil != code);
  
  @synchronized (self.observersMap) {
    NSPointerArray* observers = [self.observersMap objectForKey:code.identifier];
    if (nil == observers) {
      [self.observersMap setObject:[NSPointerArray weakObjectsPointerArray] forKey:code.identifier];
      observers = [self.observersMap objectForKey:code.identifier];
      SIAError_LogAssert(nil != observers);
    }
    
    [observers addPointer:(__bridge void * _Nullable)(observer)];
    [observers compact];//optimized
  }
  
  [observer retainToTarget];
}


- (void)removeObserver:(nonnull SIAErrorObserver*)observer {  
  @synchronized (self.observersMap) {
    for (NSPointerArray* observers in [self.observersMap allValues]) {
      [observers compact];
      
      for(NSUInteger i = 0; i < observers.count; i++) {
        if ([observers pointerAtIndex:i] == (__bridge void * _Nullable)(observer)) {
          [observers removePointerAtIndex:i];
          break;
        }
      }
    }
  }
  [observer releaseFromTarget];
  
}

@end

