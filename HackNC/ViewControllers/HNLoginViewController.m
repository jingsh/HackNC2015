//
//  HNLoginViewController.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNLoginViewController.h"
#import "HNConstants.h"

#import "UIImage+FlatUI.h"
#import "UIColor+FlatUI.h"

@import Masonry;
@import ChameleonFramework;

@import ParseFacebookUtilsV4;
@import FBSDKCoreKit;

@import QuartzCore;

static const CGFloat buttonHeight = 44.0f;
static const CGFloat horizontalPadding = 30.0f;

@interface HNLoginViewController ()
@property(nonatomic,copy)loginCompletionHandler hanlder;
@property(nonatomic,strong) NSArray *facebookPermissions;
@end

@implementation HNLoginViewController
-(instancetype)initLoginController:(loginCompletionHandler)completionHandler{
	self = [super init];
	if (self) {
		_hanlder = completionHandler;
		_facebookPermissions = @[@"public_profile",@"email",@"user_friends"];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView *background = [UIImageView new];
	[self.view addSubview:background];
	[background setImage:[UIImage imageNamed:@"loginBkg.png"]];
	
	UIButton *facebookButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, screenWidth, buttonHeight)];
	[facebookButton setTitle:@"Log In with Facebook" forState:UIControlStateNormal];
	[facebookButton setBackgroundImage:[UIImage imageWithColor:[UIColor facebookColor]] forState:UIControlStateNormal];
	[facebookButton setBackgroundImage:[UIImage imageWithColor:[UIColor facebookColorDark]] forState:UIControlStateHighlighted];
	[facebookButton setImage:[UIImage imageNamed:@"facebookIcon.png"] forState:UIControlStateNormal];
	[facebookButton setImage:[UIImage imageNamed:@"facebookIcon.png"] forState:UIControlStateHighlighted];
	[facebookButton addTarget:self action:@selector(loginUserWithFacebook:) forControlEvents:UIControlEventTouchUpInside];
	facebookButton.layer.cornerRadius = 4.0f;
	facebookButton.layer.masksToBounds = YES;
	
	[self.view addSubview:facebookButton];
	
	[background mas_makeConstraints:^(MASConstraintMaker *maker){
		maker.edges.equalTo(self.view);
	}];
	
	[facebookButton mas_makeConstraints:^(MASConstraintMaker *maker){
		maker.centerX.mas_equalTo(self.view.mas_centerX);
		maker.width.mas_equalTo(screenWidth-2*horizontalPadding);
		maker.height.mas_equalTo(buttonHeight);
		maker.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-buttonHeight);
	}];
	
	[facebookButton.imageView mas_makeConstraints:^(MASConstraintMaker *maker){
		maker.centerY.mas_equalTo(facebookButton.mas_centerY);
		maker.left.mas_equalTo(facebookButton.mas_left).with.offset(10);
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginUserWithFacebook:(id)sender{
	NSLog(@"Login with facebook");
	
	__weak typeof(self) weakSelf = self;
	PFUserResultBlock resultBlock = ^(PFUser *user, NSError *error){
		__strong typeof(weakSelf) strongSelf = weakSelf;
		strongSelf.hanlder(user,error);
	};
	
	//using v4 APIs
	if ([self permissionsContainFacebookPublishPermissions:self.facebookPermissions]) {
		[PFFacebookUtils logInInBackgroundWithPublishPermissions:self.facebookPermissions block:resultBlock];
	}else{
		[PFFacebookUtils logInInBackgroundWithReadPermissions:self.facebookPermissions block:resultBlock];
	}
}

-(BOOL)permissionsContainFacebookPublishPermissions:(NSArray *)permissions{
	for (NSString *permission in permissions) {
		if ([permission hasPrefix:@"publish"] ||
			[permission hasPrefix:@"manage"] ||
			[permission isEqualToString:@"ads_management"] ||
			[permission isEqualToString:@"create_event"] ||
			[permission isEqualToString:@"rsvp_event"]) {
			return YES;
		}
	}
	return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
