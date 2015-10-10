//
//  HNLoginViewController.h
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "ViewController.h"
@import Parse;

typedef void (^loginCompletionHandler)(PFUser *user, NSError *error);

@interface HNLoginViewController : ViewController

-(instancetype)initLoginController:(loginCompletionHandler)completionHandler;

@end
