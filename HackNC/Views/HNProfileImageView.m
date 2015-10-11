//
//  HNProfileImageView.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNProfileImageView.h"
#import "HNConstants.h"

@import ParseUI;
@import Masonry;
@import QuartzCore;

@interface HNProfileImageView ()
@property(nonatomic,strong) PFImageView *imageView;
@end

@implementation HNProfileImageView

-(instancetype)init{
	self = [super init];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.imageView = [[PFImageView alloc]init];
		[self addSubview:self.imageView];
		[self.imageView mas_makeConstraints:^(MASConstraintMaker *maker){
			maker.edges.equalTo(self);
		}];
	}
	self.userInteractionEnabled = NO;
	self.exclusiveTouch = NO;
	return self;
}

-(instancetype)initWithSize:(CGFloat)size{
	self = [super initWithFrame:CGRectMake(0, 0, size, size)];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.imageView = [[PFImageView alloc]initWithFrame:CGRectMake(0, 0, size, size)];
		
		self.imageView.layer.cornerRadius = size/2;
		self.imageView.layer.masksToBounds = YES;
		
		[self addSubview:self.imageView];
	}
	return self;
}

-(void)setUser:(PFUser *)user{
	PFFile *imageData = [user objectForKey:HNUserImageKey];
	if (imageData) {
		self.imageView.file = imageData;
		//[self.imageView loadInBackground];
		[self.imageView loadInBackground:^(UIImage *PFUI_NULLABLE_S image,  NSError *PFUI_NULLABLE_S error){
			if (!error) {
				NSData *data = UIImageJPEGRepresentation(image, 0.7);
			}
		}];
	}
	else{
		self.imageView.image = [UIImage imageNamed:@"profilePlaceHolder.png"];
	}
}

-(void)setImage:(NSData *)imageData{
	if (imageData) {
		self.imageView.image = [UIImage imageWithData:imageData];
	}
}

-(void)setSize:(CGFloat)size{
	self.layer.cornerRadius = size/2;
	self.layer.masksToBounds = YES;
}


@end
