//
//  HNContactsViewController.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNContactsViewController.h"

#import "HNFriendCell.h"

@import Parse;
@import AddressBook;

@interface HNContactsViewController () <HNAddFriendCellDelegate>
@property(nonatomic,strong) NSArray *registeredUsers;
@property(nonatomic,strong)NSMutableDictionary *connections;
@end

@implementation HNContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Find Friends";
	
	_registeredUsers = [NSArray array];
	_connections = [NSMutableDictionary dictionary];
	
	if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
		ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
		ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
			if (!granted) {
				NSLog(@"User denied address book access...");
				dispatch_async(dispatch_get_main_queue(), ^{
					UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Permission needed!" message:@"This app needs to access your contacts to find friends" preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
					UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
						[[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
					}];
					[alert addAction:cancelAction];
					[alert addAction:settingAction];
					[self presentViewController:alert animated:YES completion:nil];
				});
			}
		});
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self loadData];
}

-(void)loadData{
	NSPredicate *queryConstraint = [NSPredicate predicateWithFormat:@"fromUser = %@ OR toUser = %@",[PFUser currentUser],[PFUser currentUser]];
	PFQuery *friendShipQuery = [PFQuery queryWithClassName:@"Friendship" predicate:queryConstraint];
	[friendShipQuery includeKey:@"fromUser"];
	[friendShipQuery includeKey:@"toUser"];
	[friendShipQuery orderByDescending:@"friends"];
	
	[friendShipQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
		if (!error) {
			self.registeredUsers = objects;
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.tableView reloadData];
			});
		}
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.registeredUsers.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 44.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return @"Friends";
	}
	return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifier = @"cell";
	
	HNFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell) {
		cell = [[HNFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	cell.delegate = self;
	
	PFObject *connection = [self.registeredUsers objectAtIndex:indexPath.row];
	
	PFUser *fromUser = [connection objectForKey:@"fromUser"];
	PFUser *toUser = [connection objectForKey:@"toUser"];
	PFUser *user = [fromUser.objectId isEqualToString:[PFUser currentUser].objectId]?toUser:fromUser;
	
	[cell setUser:user connectionStatus:[(NSNumber *)[connection objectForKey:@"friends"]integerValue]];
	
	return cell;
	
}

#pragma mark - Cell delegate
-(void)cell:(HNFriendCell *)cell didTapFriendButton:(PFUser *)user{
	
}

@end
