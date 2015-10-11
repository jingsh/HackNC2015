//
//  HNLocationManager.h
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

typedef void (^permissionCallback)(BOOL granted);

@interface HNLocationManager : NSObject
@property(nonatomic,readonly) CLLocation *currentLocation;

+(instancetype)sharedLocationService;
-(void)startUpdatingLocation;

@end
