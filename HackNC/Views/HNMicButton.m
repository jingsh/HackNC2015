//
//  HNMicButton.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNMicButton.h"
#import "UIImage+FlatUI.h"
#import "UIImage+ImageEffects.h"

#import "UIColor+FlatUI.h"
#import "MultiplePulsingHaloLayer.h"

@import FontAwesomeKit;
@import ChameleonFramework;

@interface HNMicButton ()

@end

@implementation HNMicButton

-(instancetype)init{
	self = [super init];
	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		
		[self setStatedRecording:NO];
	}
	return self;
}

-(void)setStatedRecording:(BOOL)recording{
	_isRecording = recording;
	
	UIImage *image = [UIImage imageWithStackedIcons:@[[FAKIonIcons iosMicIconWithSize:70],[FAKIonIcons iosCircleOutlineIconWithSize:90]] imageSize:CGSizeMake(100, 100)];
	UIColor *color, *pressedColor;
	if (recording) {
		color = [UIColor flatRedColor];
		pressedColor = [UIColor flatRedColorDark];
		
	}else{
		color = [UIColor flatSkyBlueColor];
		pressedColor = [UIColor flatSkyBlueColorDark];
	}
	[self setImage:[image imageWithTintColor:color] forState:UIControlStateNormal];
	[self setImage:[image imageWithTintColor:pressedColor] forState:UIControlStateHighlighted];
}

@end
