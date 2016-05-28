//
//  SIAErrorCollection.h
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAError.h"

@interface SIAErrorCollection : NSObject

- (nonnull SIAError*)addError:(nonnull SIAError*)error;

- (nonnull SIAError*)addErrorByCode:(nonnull SIAErrorCode* const)code;
- (nonnull SIAError*)addErrorByCode:(nonnull SIAErrorCode* const)code WithInfo:(nullable NSDictionary*)info;

- (nullable SIAError*)addErrorByCode:(nonnull SIAErrorCode* const)code UseNSError:(nullable NSError*)error;

- (nonnull NSArray<SIAError*>*)addErrors:(nonnull SIAErrorCollection*)errorCollection;

- (BOOL)empty;
- (BOOL)has:(nonnull SIAError*)error;

- (nonnull NSArray<SIAError*>*)errors;

- (void)clean;

@end

