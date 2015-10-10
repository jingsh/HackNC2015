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

@import Parse;
@import ParseFacebookUtilsV4;

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
				//update
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

@end
