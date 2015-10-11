//
//  HNSettingsController.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNSettingsController.h"
#import "AddPhraseViewController.h"

#import "HNCache.h"
#import "HNConstants.h"

#import "HNRootViewController.h"

@import ChameleonFramework;
@import Masonry;

@interface HNSettingsController ()
@property(nonatomic,strong) NSMutableDictionary *phrases;
@end

@implementation HNSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Settings";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPhrase:)];
	
	_phrases = [@{@"duke sucks":@{@"receiver":@"9192658870",@"method":@"SMS"},@"hack":@{@"receiver":@"9192599266",@"method":@"Call"},@"carolina":@{@"receiver":@"9196999542",@"method":@"SMS"}}mutableCopy];
	[[HNCache sharedCache]setCachedPhrases:_phrases];
	//_phrases = [NSMutableDictionary dictionary];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self loadData];
}


-(void)addPhrase:(id)sender{
	AddPhraseViewController *add = [[AddPhraseViewController alloc]initWithStyle:UITableViewStyleGrouped];
	UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:add];
	[self presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
	_phrases = [[HNCache sharedCache]cachedPhrases];
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [[_phrases allKeys]count];
	}
	return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (section == 0 && [[_phrases allKeys]count]>0) {
		return @"Distress calls";
	}
	else if (section==1) return @"Log out";
	return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	if (indexPath.section == 0) {
		cell.textLabel.text = [[_phrases allKeys]objectAtIndex:indexPath.row];
	}
	else{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setTitle:@"Log out" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor flatRedColor] forState:UIControlStateNormal];
		[button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[button addTarget:(HNRootViewController *)[UIApplication sharedApplication].keyWindow.rootViewController action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *maker){
			maker.edges.equalTo(cell.contentView);
		}];
	}
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
