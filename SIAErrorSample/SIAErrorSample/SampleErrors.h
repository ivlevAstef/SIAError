//
//  SampleErrors.h
//  SIAErrorSample
//
//  Created by Alexander Ivlev on 25/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIAError/SIAErrorCodes.h"

#define SAMPLE_ERRORS(X)                            \
  X(Undefined, 100, @"Undefined Text")              \
  X(OtherError1, 200, @"Other Error 1 description") \
  X(OtherError2, 250, @"Other Error 2 description") \
  X(MainError, 350, @"Main error description")

SIA_ERROR_CODES_INTERFACE(SampleErrors, SAMPLE_ERRORS)