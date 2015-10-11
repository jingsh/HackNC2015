//
//  AddPhraseViewController.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "AddPhraseViewController.h"
#import "HNConstants.h"
#import "HNCache.h"


@import Parse;
@import Masonry;

@interface AddPhraseViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) NSMutableDictionary *phrase;
@property(nonatomic,strong) NSMutableDictionary *users;
@end

@implementation AddPhraseViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.title = @"Add Phrases";
	
	_phrase = [NSMutableDictionary dictionary];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	_users = [[HNCache sharedCache]cachedUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismiss:(id)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)save:(id)sender{
	NSMutableDictionary *phrases = [[HNCache sharedCache]cachedPhrases];
	[phrases setObject:_phrase forKey:[_phrase objectForKey:@"key"]];
	[[HNCache sharedCache]setCachedPhrases:phrases];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}
	else if (section == 1){
		return [[[[HNCache sharedCache]cachedUsers]allKeys]count]+1;
	}
	else if (section == 2){
		return 3;
	}
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return @"Phrase:";
	}
	else if (section == 1){
		return @"Recipient:";
	}
	else if (section == 2){
		return @"Deliver method:";
	}
	else return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifer = [NSString stringWithFormat:@"%li-%li",indexPath.section,indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
	}
	
	if (indexPath.section == 0) {
		UITextField *textField = [[UITextField alloc]init];
		[cell.contentView addSubview:textField];
		textField.delegate = self;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		[textField mas_makeConstraints:^(MASConstraintMaker *maker){
			maker.top.mas_equalTo(cell.contentView.mas_top).with.offset(5);
			maker.left.mas_equalTo(cell.contentView.mas_left).with.offset(10);
			maker.right.mas_equalTo(cell.contentView.mas_right).with.offset(-10);
			maker.bottom.mas_equalTo(cell.contentView.mas_bottom).with.offset(-5);
		}];
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = [[PFUser currentUser]objectForKey:HNUserNameKey];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		else{
			NSDictionary *thisUser = [_users objectForKey:[[_users allKeys]objectAtIndex:indexPath.row-1]];
			NSString *name = [thisUser objectForKey:@"name"];
			
			cell.textLabel.text = name;
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else if (indexPath.section == 2){
		if (indexPath.row == 0) {
			cell.textLabel.text = @"SMS";
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		else if (indexPath.row == 1){
			cell.textLabel.text = @"Call";
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		else if (indexPath.row == 2){
			cell.textLabel.text = @"Push Notifications";
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 1) {
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
	if (indexPath.section == 1) {
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
}


@end
