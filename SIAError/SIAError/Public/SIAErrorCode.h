//
//  SIAErrorCode.h
//  SIAError
//
//  Created by Alexander Ivlev on 25/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NSNumber* SIAErrorCodeIdentifier;

@interface SIAErrorCode : NSObject

+ (nonnull SIAErrorCode*)createWithPriority:(NSInteger)priority AndText:(nonnull NSString*)text;

- (nonnull id)initWithPriority:(NSInteger)priority AndText:(nonnull NSString*)text;
- (nonnull id)init __attribute__((unavailable("Use initWithPriority:AndText:")));

@property (readonly, nonatomic) NSInteger priority;
@property (readonly, nonatomic, nonnull) NSString* text;

@property (readonly, nonatomic, nonnull) SIAErrorCodeIdentifier identifier;

@end
