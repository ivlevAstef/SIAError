//
//  SIAErrorManager.h
//  SIAError
//
//  Created by Alexander Ivlev on 25/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAErrorCollection.h"
#import "SIAErrorObserverIdentifier.h"

@interface SIAErrorManager : NSObject

+ (nonnull id<SIAErrorObserverIdentifier>)subscibeToOne:(nonnull SIAErrorCode* const)code Target:(nonnull id)target Selector:(nonnull SEL)selector;
+ (nonnull id<SIAErrorObserverIdentifier>)subscibeToOne:(nonnull SIAErrorCode* const)code Target:(nonnull id)target Callback:(_Nonnull SIAErrorObserverCallback)callback;

+ (nonnull id<SIAErrorObserverIdentifier>)subscibeToArray:(nonnull NSArray<SIAErrorCode*>*)codes Target:(nonnull id)target Selector:(nonnull SEL)selector;
+ (nonnull id<SIAErrorObserverIdentifier>)subscibeToArray:(nonnull NSArray<SIAErrorCode*>*)codes Target:(nonnull id)target Callback:(_Nonnull SIAErrorObserverCallback)callback;

+ (void)unsubscribe:(nonnull id<SIAErrorObserverIdentifier>)observer;

+ (void)notify:(nonnull SIAError*)error;
+ (void)notifyAll:(nonnull SIAErrorCollection*)collection;
+ (void)notifyMaxPriority:(nonnull SIAErrorCollection*)collection;

@end

