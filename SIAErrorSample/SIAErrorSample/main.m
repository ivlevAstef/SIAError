//
//  main.m
//  SIAErrorSample
//
//  Created by Alexander Ivlev on 20/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIAError/SIAErrorThread.h"
#import "SIAError/SIAErrorManager.h"
#import "SampleErrors.h"

@interface SampleObserver : NSObject

@end

@implementation SampleObserver

- (BOOL)sampleSelector:(nonnull SIAError*)error {
  NSLog(@"Receive selector error: %@", [error description]);
  return TRUE;
}

- (BOOL)sampleMainSelector:(nonnull SIAError*)error {
  NSLog(@"Main Receive selector error: %@", [error description]);
  return FALSE;
}

@end

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    SampleObserver* mainTarget = [[SampleObserver alloc] init];
    [SIAErrorManager subscibeToArray:@[[SIAErrorCodes OtherError1], [SIAErrorCodes OtherError2], [SIAErrorCodes MainError]] Target:mainTarget Callback:^BOOL(SIAError* _Nonnull error) {
      NSLog(@"Main Receive callback error: %@", [error description]);
      return FALSE;
    }];
    
    [SIAErrorManager subscibeToOne:[SIAErrorCodes MainError] Target:mainTarget Selector:@selector(sampleMainSelector:)];
    __block id observer = [SIAErrorManager subscibeToArray:@[[SIAErrorCodes OtherError2], [SIAErrorCodes MainError]] Target:mainTarget Selector:@selector(sampleMainSelector:)];
    
    __block SIAErrorCollection* mainCollection = nil;
    
    NSOperationQueue* queue = [NSOperationQueue new];
    [queue addOperationWithBlock:^{
        SampleObserver* target = [[SampleObserver alloc] init];
        [SIAErrorManager subscibeToArray:@[[SIAErrorCodes OtherError1], [SIAErrorCodes OtherError2]] Target:target Callback:^BOOL(SIAError* _Nonnull error) {
          NSLog(@"Receive callback error: %@", [error description]);
          return FALSE;
        }];
        
        [SIAErrorManager subscibeToArray:@[[SIAErrorCodes OtherError1], [SIAErrorCodes OtherError2]] Target:target Selector:@selector(sampleSelector:)];
        
        [SIAErrorManager subscibeToArray:@[[SIAErrorCodes OtherError1], [SIAErrorCodes OtherError2], [SIAErrorCodes MainError]] Target:target Callback:^BOOL(SIAError* _Nonnull error) {
          NSLog(@"No Show because last method return TRUE.");
          return FALSE;
        }];
        
        [SIAErrorThread addError:[SIAError createByCode:[SIAErrorCodes OtherError1]]];
        [SIAErrorThread addError:[SIAError createByCode:[SIAErrorCodes OtherError2]]];
        
        
        SIAErrorCollection* collection = [SIAErrorThread toCollection];
        
        NSLog(@"Notify all");
        [SIAErrorManager notifyAll:collection];
        NSLog(@"Notify max priority");
        [SIAErrorManager notifyMaxPriority:collection];
        
        //no notify because 'toCollection' clean error thread errors.
        [SIAErrorManager notifyAll:[SIAErrorThread toCollection]];
        
        [SIAErrorThread addError:[SIAError createByCode:[SIAErrorCodes MainError]]];
        [SIAErrorThread addError:[SIAError createByCode:[SIAErrorCodes OtherError2]]];
        mainCollection = [SIAErrorThread toCollection];
        
      
    }];
    
    [queue waitUntilAllOperationsAreFinished];
    
    [SIAErrorManager unsubscribe:observer];
    NSLog(@"Notify Main max priority");
    [SIAErrorManager notifyMaxPriority:mainCollection];
  }
  return 0;
}
