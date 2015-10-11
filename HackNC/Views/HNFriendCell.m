//
//  HNFriendCell.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNFriendCell.h"
#import "HNProfileImageView.h"
#import "UIImage+ImageEffects.h"
#import "HNCache.h"

@import FontAwesomeKit;
@import ChameleonFramework;

typedef void (^HNButtonSelectionBlock)(void) ;

@interface HNFriendButton : UIButton
@property(nonatomic,copy)HNButtonSelectionBlock selectionBlock;
+(instancetype)button;
+(instancetype)buttonWithRequestStyle:(HNFriendStatus)status selectionHandler:(HNButtonSelectionBlock)handler;
-(void)setSelectionHandler:(HNButtonSelectionBlock)handler;
-(void)setButtonStyle:(HNFriendStatus)status;
@end

@implementation HNFriendButton

+(instancetype)button{
	return [HNFriendButton buttonWithType:UIButtonTypeCustom];
}

+(instancetype)buttonWithRequestStyle:(HNFriendStatus)status selectionHandler:(HNButtonSelectionBlock)handler{
	HNFriendButton *button = [HNFriendButton button];
	[button setButtonStyle:status];
	[button setSelectionBlock:handler];
	[button addTarget:button action:@selector(friendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}


-(void)setSelectionHandler:(HNButtonSelectionBlock)handler{
	self.selectionBlock = handler;
}

-(void)setButtonStyle:(HNFriendStatus)status{
	UIImage *image;
	switch (status) {
		case kFriendStatusNone:{
			image = [[FAKIonIcons personAddIconWithSize:25]imageWithSize:CGSizeMake(25, 25)];
			[self setImage:[image imageWithTintColor:[UIColor flatBlackColor]] forState:UIControlStateNormal];
			[self setImage:[image imageWithTintColor:[UIColor flatBlackColorDark]] forState:UIControlStateHighlighted];
		}
			break;
		case kFriendStatusFriend:{
			image = [[FAKFoundationIcons torsosIconWithSize:25]imageWithSize:CGSizeMake(25, 25)];
			[self setImage:[image imageWithTintColor:[UIColor flatMintColor]] forState:UIControlStateNormal];
			[self setImage:[image imageWithTintColor:[UIColor flatMintColorDark]] forState:UIControlStateHighlighted];
		}
			break;
		case kFriendStatusPending:{
			image = [[FAKIonIcons iosHelpIconWithSize:25]imageWithSize:CGSizeMake(25, 25)];
			[self setImage:[image imageWithTintColor:[UIColor flatOrangeColor]] forState:UIControlStateNormal];
			[self setImage:[image imageWithTintColor:[UIColor flatOrangeColorDark]] forState:UIControlStateHighlighted];
		}
			break;
		default:
			break;
	}
}

-(void)friendButtonTapped:(id)sender{
	if (self.selectionBlock) {
		self.selectionBlock();
	}
}
@end




@import Masonry;
@import ChameleonFramework;

static const CGFloat horizontalSpacing = 10.0f;
static const CGFloat verticalSpacing = 10.0f;

@interface HNFriendCell ()
@property(nonatomic,strong) HNProfileImageView *profile;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *emailLabel;
@property(nonatomic,strong) HNFriendButton *friendButton;
@property(nonatomic) HNFriendStatus status;

@property(nonatomic,strong) PFUser *targetUser;
@end

@implementation HNFriendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	self.contentView.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
	
	_profile = [[HNProfileImageView alloc]initWithSize:30];
	[self.contentView addSubview:_profile];
	
	_nameLabel = [UILabel new];
	[_nameLabel setBackgroundColor:[UIColor clearColor]];
	[_nameLabel setTextColor:[UIColor flatBlackColor]];
	[_nameLabel setFont:[UIFont systemFontOfSize:16]];
	[_nameLabel setTextAlignment:NSTextAlignmentLeft];
	[self.contentView addSubview:_nameLabel];
	
	_emailLabel = [UILabel new];
	[_emailLabel setBackgroundColor:[UIColor clearColor]];
	[_emailLabel setTextColor:[UIColor flatBlackColor]];
	[_emailLabel setFont:[UIFont systemFontOfSize:14]];
	[_emailLabel setTextAlignment:NSTextAlignmentLeft];
	[self.contentView addSubview:_emailLabel];
	
	
	_status = kFriendStatusNone;
	_friendButton = [HNFriendButton buttonWithRequestStyle:_status selectionHandler:^{
		if (_status == kFriendStatusNone) {
			if (self.delegate) {
				[self.delegate cell:self didTapFriendButton:self.targetUser];
			}
		}
	}];
	
	[self.contentView addSubview:_friendButton];
	
	//layout
	[_profile mas_remakeConstraints:^(MASConstraintMaker *maker){
		maker.left.mas_equalTo(self.contentView.mas_left).with.offset(horizontalSpacing);
		maker.top.mas_equalTo(self.contentView.mas_top).with.offset(verticalSpacing);
		maker.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(verticalSpacing);
		maker.width.mas_equalTo(30);
	}];
	
	[_nameLabel mas_makeConstraints:^(MASConstraintMaker *maker){
		maker.left.mas_equalTo(_profile.mas_right).with.offset(horizontalSpacing);
		maker.top.mas_equalTo(self.contentView.mas_top).with.offset(verticalSpacing/2);
		maker.right.mas_equalTo(_friendButton.mas_left).with.offset(-horizontalSpacing);
		maker.bottom.mas_equalTo(_emailLabel.mas_top).with.offset(-verticalSpacing/2);
		maker.height.mas_equalTo(20);
	}];
	
	[_emailLabel mas_makeConstraints:^(MASConstraintMaker *maker){
		maker.left.mas_equalTo(_nameLabel.mas_left);
		maker.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-verticalSpacing/2);
		maker.right.mas_equalTo(_nameLabel.mas_right);
		maker.height.mas_equalTo(15);
	}];
	
	[_friendButton mas_makeConstraints:^(MASConstraintMaker *maker){
		maker.centerY.mas_equalTo(self.contentView.mas_centerY);
		maker.right.mas_equalTo(self.contentView.mas_right).with.offset(-horizontalSpacing);
		maker.width.mas_equalTo(30);
		maker.height.mas_equalTo(30);
	}];
	
	return self;
}

-(void)setUser:(PFUser *)user connectionStatus:(HNFriendStatus)status{
	NSString *name = [user objectForKey:HNUserNameKey];
	NSString *email = user.email;
	
	NSData *imageData;
	if ([[[HNCache sharedCache]cachedUsers]objectForKey:user.objectId]) {
		imageData = [[[HNCache sharedCache]cachedUsers]objectForKey:user.objectId];
	}
	else{
		NSString *url = [user objectForKey:HNUserImagePicURLKey];
		imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
		NSMutableDictionary *dict = [[HNCache sharedCache]cachedUsers];
		[dict setObject:imageData forKey:user.objectId];
		[[HNCache sharedCache]setCachedUsers:dict];
	}
	[_profile setImage:imageData];
	
	//[_profile setUser:user];
	[_nameLabel setText:name];
	[_emailLabel setText:email];
	_targetUser = user;
	
	_status = status+1;
	
	[_friendButton setButtonStyle:_status];
}


@end
