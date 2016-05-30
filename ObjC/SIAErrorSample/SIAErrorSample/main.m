//
//  main.m
//  SIAErrorSample
//
//  Created by Alexander Ivlev on 20/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIAErrorThread.h"
#import "SIAErrorManager.h"
#import "SampleErrors.h"

@interface SampleTarget : NSObject

@end

@implementation SampleTarget

- (BOOL)sampleSelector:(nonnull SIAError*)error {
  NSLog(@"Receive selector error: %@", [error description]);
  return TRUE;
}

- (BOOL)sampleMainSelector:(nonnull SIAError*)error {
  NSLog(@"Main Receive selector error: %@", [error description]);
  return FALSE;
}

@end

SampleTarget* sampleSubscibeMain() {
  SampleTarget* target = [[SampleTarget alloc] init];
  
  [SIAErrorManager subscibeToArray:[SIAErrorCodes Any] Target:target Callback:^BOOL(SIAError* _Nonnull error) {
    NSLog(@"Main Receive callback error: %@", [error description]);
    return FALSE;
  }];
  
  [SIAErrorManager subscibeToOne:[SIAErrorCodes MainError] Target:target Selector:@selector(sampleMainSelector:)];
  
  return target;
}

id<SIAErrorObserverIdentifier> sampleObserverForUnbind(SampleTarget* target) {
  NSArray* validErrorCodes2 = @[[SIAErrorCodes OtherError2], [SIAErrorCodes MainError]];
  return [SIAErrorManager subscibeToArray:validErrorCodes2 Target:target Selector:@selector(sampleMainSelector:)];
}

SampleTarget* sampleSubscribe() {
  SampleTarget* target = [[SampleTarget alloc] init];
  
  NSArray* validErrorCodes = [SIAErrorCodes AnyWithout:@[[SIAErrorCodes MainError]]];
  [SIAErrorManager subscibeToArray:validErrorCodes Target:target Callback:^BOOL(SIAError* _Nonnull error) {
    NSLog(@"Receive callback error: %@", [error description]);
    return FALSE;
  }];
  
  [SIAErrorManager subscibeToOne:[SIAErrorCodes OtherError2] Target:target Selector:@selector(sampleSelector:)];
  
  [SIAErrorManager subscibeToArray:[SIAErrorCodes Any] Target:target Callback:^BOOL(SIAError* _Nonnull error) {
    NSLog(@"No Show because last method return TRUE.");
    return FALSE;
  }];
  
  return target;
}

void sampleCallNotify() {
  SIAErrorCollection* collection = [SIAErrorThread toCollection];
  
  NSLog(@"Notify all");
  [SIAErrorManager notifyAll:collection];
  NSLog(@"Notify max priority");
  [SIAErrorManager notifyMaxPriority:collection];
  
  //no notify because 'toCollection' clean thread errors.
  [SIAErrorManager notifyAll:[SIAErrorThread toCollection]];

}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    SampleTarget* mainTarget = sampleSubscibeMain();
    id<SIAErrorObserverIdentifier> observer = sampleObserverForUnbind(mainTarget);
    
    __block SIAErrorCollection* mainCollection = nil;
    
    NSOperationQueue* queue = [NSOperationQueue new];
    [queue addOperationWithBlock:^{
      SampleTarget* __attribute__((unused)) threadTarget = sampleSubscribe();
      
      [SIAErrorThread addError:[SIAError createByCode:[SIAErrorCodes OtherError1]]];
      [SIAErrorThread addError:[SIAError createByCode:[SIAErrorCodes OtherError2]]];
      
      sampleCallNotify();
      
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
