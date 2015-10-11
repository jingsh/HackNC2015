//
//  HNFriendCell.h
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;
#import "HNConstants.h"

@class HNFriendCell;

@protocol HNAddFriendCellDelegate <NSObject>

-(void)cell:(HNFriendCell *)cell didTapFriendButton:(PFUser *)user;

@end


@interface HNFriendCell : UITableViewCell
@property(nonatomic,weak)id<HNAddFriendCellDelegate>delegate;

-(void)setUser:(PFUser *)user connectionStatus:(HNFriendStatus)status;
@end
