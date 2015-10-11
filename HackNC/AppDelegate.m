//
//  AppDelegate.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;
@import AVFoundation;
@import ChameleonFramework;

#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

#import "HNRootViewController.h"

#import "HNLocationManager.h"

@import ApiAI;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	// Initialize Parse.
	[Parse setApplicationId:@"HU9hwFTIdAQolkL68VtwMqEUtzzqIlMTHmHr4Evf"
				  clientKey:@"9sCNSBQ6Dcp8kNXslLRmayUIueo2d2a195xgjGu9"];
	[PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
	
	
	[GMSServices provideAPIKey:@"AIzaSyB997sejTuYKuAsenSjQQLHT5GGbCC5Wdg"];
	
	[self setGlobalApperance];
	
	UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
	
	[application registerUserNotificationSettings:settings];
	
	[application registerForRemoteNotifications];
	
	[self.window makeKeyAndVisible];
	
	//Init voice recoginition
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	[[AVAudioSession sharedInstance] setActive:YES error:nil];
	
	ApiAI *apiai = [ApiAI sharedApiAI];
	
	id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
	
	configuration.clientAccessToken = @"cf8a067eb74146838135e4aaa451cf40";
	configuration.subscriptionKey = @"144bb0bc-8472-4aa4-9449-b947e13d818b";
	
	apiai.configuration = configuration;
	
	[[HNLocationManager sharedLocationService]startUpdatingLocation];
	
	
	return [[FBSDKApplicationDelegate sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
	return [[FBSDKApplicationDelegate sharedInstance]application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}


#pragma mark - Push Notif
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
	PFInstallation *installation = [PFInstallation currentInstallation];
	[installation setDeviceTokenFromData:deviceToken];
	[installation saveInBackground];
}


#pragma mark - App apperance
-(void)setGlobalApperance{
	[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
	[[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance]setBarTintColor:[UIColor flatSkyBlueColor]];
	[[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f]}];
	[[UINavigationBar appearance]setTranslucent:YES];
	[[UINavigationBar appearance]setBarStyle:UIBarStyleBlackTranslucent];
}



@end
