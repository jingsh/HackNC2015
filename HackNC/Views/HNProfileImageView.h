//
//  HNProfileImageView.h
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

@interface HNProfileImageView : UIView

-(instancetype)initWithSize:(CGFloat)size;

-(void)setUser:(PFUser *)user;

-(void)setImage:(NSData *)imageData;

-(void)setSize:(CGFloat)size;

@end
