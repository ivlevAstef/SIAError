//
//  SIAErrorObserver.h
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIAErrorObserverIdentifier.h"

@interface SIAErrorObserver : NSObject<SIAErrorObserverIdentifier>

- (nonnull id)initWithTarget:(nonnull id)target AndSelector:(nonnull SEL)selector;
- (nonnull id)initWithTarget:(nonnull id)target AndCallback:(nonnull SIAErrorObserverCallback)callback;

- (BOOL)notify:(nonnull SIAError*)error;

@end

@interface SIAErrorObserver (LifeTime)

- (void)retainToTarget;
- (void)releaseFromTarget;

@end