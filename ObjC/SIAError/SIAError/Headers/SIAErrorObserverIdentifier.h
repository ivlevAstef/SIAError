//
//  SIAErrorObserverIdentifier.h
//  SIAError
//
//  Created by Alexander Ivlev on 25/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIAError.h"

/**
 *  @return TRUE if method process error, and don't need call other observers, otherwise FALSE.
 */
typedef BOOL (^SIAErrorObserverCallback)(SIAError* _Nonnull error);

@protocol SIAErrorObserverIdentifier <NSObject>

@end
