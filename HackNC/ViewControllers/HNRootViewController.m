//
//  HNRootViewController.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNRootViewController.h"

#import "HNHomeViewController.h"
#import "HNLoginViewController.h"

#import "HNConstants.h"

@import Parse;
@import ParseFacebookUtilsV4;
@import FBSDKCoreKit;

@interface HNRootViewController ()

@end

@implementation HNRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	if ([PFUser currentUser]) {
		[self presentHomeViewController];
	}else{
		[self presentLoginViewController];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentLoginViewController{
	HNLoginViewController *loginController = [[HNLoginViewController alloc]initLoginController:^(PFUser *user, NSError *error){
		if (user) {
			if ([PFFacebookUtils isLinkedWithUser:user]) {
				[self updateUser];
			}
			[self presentHomeViewController];
		}
		
	}];
	
	[self.navigationBar setHidden:YES];
	[self setRootViewController:loginController animated:YES];
}

-(void)presentHomeViewController{
	HNHomeViewController *homeController = [[HNHomeViewController alloc]init];
	[self.navigationBar setHidden:NO];
	[self setRootViewController:homeController animated:YES];
}

#pragma mark - Navigation
-(void)setRootViewController:(id)viewController animated:(BOOL)animated{
	if ([viewController isKindOfClass:[UIViewController class]]) {
		[self popToRootViewControllerAnimated:NO];
		if (animated) {
			[UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
				[self setViewControllers:@[viewController] animated:NO];
			}completion:nil];
		}else{
			[self setViewControllers:@[viewController] animated:NO];
		}
	}
}

#pragma mark - update user
-(void)updateUser{
	if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
		[[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields":@"name,email,id,gender"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){
			//@{@"fields":@"first_name,name,email,id,gender"}
			if (!error) {
				NSDictionary *userData = (NSDictionary *)result;
				NSString *facebookID = [userData objectForKey:@"id"];
				NSString *name = [userData objectForKey:@"name"];
				NSString *email = [userData objectForKey:@"email"];
				NSString *gender = [userData objectForKey:@"gender"];
				NSString *profilePicURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=320&height=320&return_ssl_resources=1",facebookID];
				//type=large
				
				PFUser *user = [PFUser currentUser];
				//fill out or update basic info
				[user setObject:name forKey:HNUserNameKey];
				[user setEmail:email];
				[user setObject:facebookID forKey:HNUserFacebookIdKey];
				[user setObject:profilePicURL forKey:HNUserImagePicURLKey];
				
				NSInteger userGender = [gender isEqualToString:@"female"]?kUserGenderFemale:kUserGenderMale;
				[user setObject:@(userGender) forKey:HNUserGenderKey];
				
				[user saveInBackground];
				
				if (profilePicURL.length>0) {
					NSURL *url = [NSURL URLWithString:profilePicURL];
					NSData *imageData = [NSData dataWithContentsOfURL:url];
					
					PFFile *imageFile = [PFFile fileWithData:imageData];
					[imageFile saveInBackgroundWithBlock:^(BOOL success, NSError *error){
						if (!error) {
							[[PFUser currentUser]setObject:imageFile forKey:HNUserImageKey];
							[[PFUser currentUser]saveInBackground];
						}
					}];
				}
			}
			else{
				NSLog(@"%@",error);
			}
		}];
	}
}

@end
