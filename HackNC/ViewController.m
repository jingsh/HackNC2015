//
//  ViewController.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "ViewController.h"

@import ApiAI;
@import Masonry;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet AIVoiceRequestButton *button;


@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[_button setSuccessCallback:^(id response){
		NSLog(@"%@",response);
	}];
	
	[_button setFailureCallback:^(NSError *error){
		NSLog(@"%@",error);
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
