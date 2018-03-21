#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BViewController.h"
#import "Target_B.h"

FOUNDATION_EXPORT double BProjectVersionNumber;
FOUNDATION_EXPORT const unsigned char BProjectVersionString[];

