//
//  HNListener.h
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^heardPhraseCallBack)(BOOL found, NSError *error);

@interface HNListener : NSObject
@property(nonatomic)BOOL isListening;

+(instancetype)sharedListener;

-(void)startListening;

-(void)stopListening;

-(void)setPhrase:(NSDictionary *)phrase;

@end
