//
//  HNLocationManager.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNLocationManager.h"
#import "HNConstants.h"

@import UIKit;
@import Parse;

@interface HNLocationManager ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLLocation *currentLocation;
@end

@implementation HNLocationManager

+(instancetype)sharedLocationService{
	static HNLocationManager *service;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		service = [[self alloc]init];
	});
	return service;
}

-(instancetype)init{
	self = [super init];
	if (self) {
		_locationManager = [[CLLocationManager alloc]init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		_locationManager.distanceFilter = 50;
	}
	return self;
}

#pragma mark - Update Location
-(void)requestLocationServiceIfNeeded:(permissionCallback)handler{
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	if (status == kCLAuthorizationStatusNotDetermined) {
		[_locationManager requestAlwaysAuthorization];
		handler(NO);
	}
	else if (status==kCLAuthorizationStatusAuthorizedWhenInUse){
		[_locationManager requestAlwaysAuthorization];
		handler(YES);
	}
	else if (status==kCLAuthorizationStatusAuthorizedAlways){
		handler(YES);
	}
	else if ((status==kCLAuthorizationStatusDenied ||status == kCLAuthorizationStatusRestricted)&&[[UIApplication sharedApplication]applicationState]==UIApplicationStateActive){
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Service Required" message:@"The app needs to know your location to share with your choice of people when necessary." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
		UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
			[[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
		}];
		[alertController addAction:cancelAction];
		[alertController addAction:settingAction];
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
		handler(NO);
	}
	else handler(NO);
}


-(void)startUpdatingLocation{
	[self requestLocationServiceIfNeeded:^(BOOL granted){
		if (granted) {
			[_locationManager startUpdatingLocation];
		}
	}];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
	CLLocation *location = [locations lastObject];
	NSDate *timeStamp = location.timestamp;
	NSTimeInterval howRecent = [timeStamp timeIntervalSinceNow];
	if (fabs(howRecent)<15.0f) {
		_currentLocation = location;
		[[NSNotificationCenter defaultCenter]postNotificationName:HNLocationUpdatedNotification object:self];
		PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:location];
		[[PFUser currentUser]setObject:point forKey:@"location"];
		[[PFInstallation currentInstallation]setObject:point forKey:@"location"];
		[[PFUser currentUser]saveInBackground];
		[[PFInstallation currentInstallation]saveInBackground];
		[_locationManager stopUpdatingLocation];
	}
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
	if (status == kCLAuthorizationStatusAuthorizedAlways) {
		[_locationManager startUpdatingLocation];
	}
}

@end
