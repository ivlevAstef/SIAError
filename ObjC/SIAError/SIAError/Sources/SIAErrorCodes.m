//
//  SIAErrorCodes.m
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import "SIAErrorCodes.h"
#import "SIAErrorLogger.h"
#import <objc/runtime.h>

@implementation SIAErrorCodes

BOOL isIgnoreMethod(Method methodMeta) {
  SEL selector = method_getName(methodMeta);
  
  return @selector(Any) == selector ||
         @selector(AnyWithout:) == selector;
}

SIAErrorCode* getErrorCodeByMethod(id self, Method methodMeta) {
  SEL selector = method_getName(methodMeta);
  IMP func = method_getImplementation(methodMeta);
  SIAErrorCode* code = ((id(*)(id, SEL))func)(self, selector);
  
  if ([code isKindOfClass:[SIAErrorCode class]]) {
    return code;
  }
  
  return nil;
}

+ (NSArray<SIAErrorCode*>*)Any {
  static dispatch_once_t onceToken;
  static NSArray<SIAErrorCode*>* result = nil;
  dispatch_once(&onceToken, ^{
    NSMutableArray* anyErrorCodes = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method* methodsMeta = class_copyMethodList(object_getClass(self), &methodCount);
    
    for (size_t i = 0; i < methodCount; i++) {
      Method methodMeta = methodsMeta[i];
      if (isIgnoreMethod(methodMeta)) {
        continue;
      }
      
      SIAErrorCode* code = getErrorCodeByMethod(self, methodMeta);
      if (nil != code) {
          [anyErrorCodes addObject:code];
      }
    }
    
    free(methodsMeta);
    
    result = [anyErrorCodes copy];
    SIAError_LogDebug(@"Load Any errors. Count:%ld", (long)result.count);
  });
  
  return result;
}

+ (NSArray<SIAErrorCode*>*)AnyWithout:(NSArray<SIAErrorCode*>*)codes {
  SIAError_LogAssert(nil != codes);
  
  NSMutableSet* result = [NSMutableSet setWithArray:[self Any]];
  [result minusSet:[NSSet setWithArray:codes]];
  
  return [result allObjects];
}

@end