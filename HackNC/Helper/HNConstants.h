//
//  HNConstants.h
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const HNLocationUpdatedNotification;

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, HNUserGender){
	kUserGenderFemale = 1,
	kUserGenderMale,
	kUserGenderUnknown
};

typedef NS_ENUM(NSInteger, HNFriendStatus){
	kFriendStatusNone = 1,
	kFriendStatusFriend,
	kFriendStatusPending
};

FOUNDATION_EXTERN NSString *const HNUserNameKey;
FOUNDATION_EXTERN NSString *const HNUserEmailKey;
FOUNDATION_EXTERN NSString *const HNUserFacebookIdKey;
FOUNDATION_EXTERN NSString *const HNUserImagePicURLKey;
FOUNDATION_EXTERN NSString *const HNUserGenderKey;
FOUNDATION_EXTERN NSString *const HNUserImageKey;

FOUNDATION_EXTERN NSString *const HNCacheUserKey;
FOUNDATION_EXTERN NSString *const HNCachePhrasesKey;


