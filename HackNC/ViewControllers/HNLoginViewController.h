//
//  HNLoginViewController.h
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

@import UIKit;
@import Parse;

typedef void (^loginCompletionHandler)(PFUser *user, NSError *error);

@interface HNLoginViewController : UIViewController

-(instancetype)initLoginController:(loginCompletionHandler)completionHandler;

@end
