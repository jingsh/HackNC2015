//
//  HNMicButton.h
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNMicButton : UIButton
@property(nonatomic)BOOL isRecording;

-(instancetype)init;

-(void)setStatedRecording:(BOOL)recording;

@end
