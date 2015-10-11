//
//  HNHomeViewController.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNHomeViewController.h"
#import "MultiplePulsingHaloLayer.h"
#import "PulsingHaloLayer.h"

#import "HNListener.h"

#import "HNContactsViewController.h"
#import "HNSettingsController.h"

@import GoogleMaps;
@import ApiAI;
@import Masonry;
@import Parse;
@import FontAwesomeKit;
@import ChameleonFramework;

#import "HNLocationManager.h"
#import "HNMicButton.h"

@interface HNHomeViewController ()<GMSMapViewDelegate>
@property(nonatomic,strong) GMSMapView *mapView;
@property(nonatomic,strong) MultiplePulsingHaloLayer *mHalo;
@property(nonatomic,strong) PulsingHaloLayer *halo;
@end

@implementation HNHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Distress Call";
	
	_mapView = [[GMSMapView alloc]init];
	_mapView.myLocationEnabled = YES;
	_mapView.indoorEnabled = YES;
	_mapView.settings.compassButton = YES;
	_mapView.settings.myLocationButton = YES;
	
	[self.view addSubview:_mapView];
	
	[_mapView mas_makeConstraints:^(MASConstraintMaker *maker){
		maker.edges.equalTo(self.view);
	}];
	
	GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:[[[HNLocationManager sharedLocationService]currentLocation]coordinate] zoom:15];
	[_mapView animateToCameraPosition:camera];
	
	HNMicButton *micButton = [[HNMicButton alloc]init];
	[micButton addTarget:self action:@selector(toggleRecording:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view insertSubview:micButton aboveSubview:_mapView];
	
	[micButton mas_makeConstraints:^(MASConstraintMaker *maker){
		maker.centerX.mas_equalTo(self.view.mas_centerX);
		maker.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-40);
	}];
	
	_halo = [PulsingHaloLayer layer];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[FAKIonIcons personAddIconWithSize:25]imageWithSize:CGSizeMake(25, 25)] style:UIBarButtonItemStylePlain target:self action:@selector(showFriendsController:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[FAKIonIcons iosGearIconWithSize:25]imageWithSize:CGSizeMake(25, 25)] style:UIBarButtonItemStylePlain target:self action:@selector(showSettingsController:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showFriendsController:(id)sender{
	HNContactsViewController *friendController = [[HNContactsViewController alloc]initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:friendController animated:YES];
}

-(void)showSettingsController:(id)sender{
	HNSettingsController *settingsController = [[HNSettingsController alloc]initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:settingsController animated:YES];
}

-(void)toggleRecording:(id)sender{
	HNMicButton *button = (HNMicButton *)sender;
	MultiplePulsingHaloLayer *halo = [[MultiplePulsingHaloLayer alloc]initWithHaloLayerNum:3 andStartInterval:1];
	halo.position = button.center;
	
	halo.radius = 60;
	halo.backgroundColor = [[UIColor flatRedColor]colorWithAlphaComponent:0.8].CGColor;
	
	BOOL recording = !button.isRecording;
	if (button.isRecording) {
		//
		[self.view.layer addSublayer:halo];
	}
	else{
		[self.view.layer addSublayer:halo];
	}
	[halo buildSublayers];
	
	if (recording) {
		//start recording
		[[HNListener sharedListener]startListening];
	}
	else{
		[[HNListener sharedListener]stopListening];
	}
	[button setStatedRecording:recording];
}

@end
