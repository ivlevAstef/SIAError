//
//  SIAErrorLogger.h
//  SIAError
//
//  Created by Alexander Ivlev on 24/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#ifndef SIAError_Logger_h
#define SIAError_Logger_h

#define SIAError_Log(LEVEL, STRING,...) NSLog(@"[SIAError] " LEVEL @": " STRING, ##__VA_ARGS__)

#define SIAError_LogError(STRING,...)   SIAError_Log(@"Error", STRING, ##__VA_ARGS__)
#define SIAError_LogWarning(STRING,...) SIAError_Log(@"Warning", STRING, ##__VA_ARGS__)
#define SIAError_LogDebug(STRING,...)   SIAError_Log(@"Debug", STRING, ##__VA_ARGS__)
#define SIAError_LogTrace(STRING,...)   SIAError_Log(@"Trace", STRING, ##__VA_ARGS__)

#define SIAError_LogAssert(CONDITION) assert(CONDITION)

#endif /* SIAError_Logger_h */
