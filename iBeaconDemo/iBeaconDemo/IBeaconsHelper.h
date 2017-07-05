//
//  IBeaconsHelper.h
//  YoMoney
//
//  Created by ilovesunnie on 1/23/15.
//  Copyright (c) 2015 Accentrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol IBeaconsHelperDelegate <NSObject>

-(void)IBeaconsHelperDetectIbeaconsArray:(NSArray*)array;

@optional
- (void)iBeaconWillDetect;

@end

@interface IBeaconsHelper : NSObject<CLLocationManagerDelegate,CBCentralManagerDelegate>

+(void)start;
+(void)stop;

+ (IBeaconsHelper *)sharedSingleton;

@property(nonatomic,weak)id<IBeaconsHelperDelegate>delegate;

+ (BOOL)isBlueToothOpen;

+ (void)check;

@end
