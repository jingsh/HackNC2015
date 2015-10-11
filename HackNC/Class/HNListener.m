//
//  HNListener.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNListener.h"
#import "HNCache.h"
#import "HNLocationManager.h"

@import ApiAI;
@import Parse;

@interface HNListener ()
@property(nonatomic,strong)ApiAI *ai;
@property(nonatomic,strong)AIVoiceRequest *request;

@end

@implementation HNListener
+(instancetype)sharedListener{
	static HNListener *listener;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		listener = [[self alloc]init];
	});
	return listener;
}

-(instancetype)init{
	self = [super init];
	if (self) {
		_ai = [ApiAI sharedApiAI];
	}
	return self;
}

-(void)startListening{
	self.isListening = YES;
	NSLog(@"Started Listening");
	_request = [_ai voiceRequest];
	__weak typeof(self) weakSelf = self;
	[_request setCompletionBlockSuccess:^(AIRequest *request, id response){
		__strong typeof(weakSelf) strSelf = weakSelf;
		[strSelf processResponse:(id)response];
		
		if (strSelf.isListening) {
			[strSelf startListening];
		}
	}failure:^(AIRequest *request, NSError *error){
		__strong typeof(weakSelf) strSelf = weakSelf;
		if (strSelf.isListening) {
			[strSelf startListening];
		}
	}];
	[_ai enqueue:_request];
}

-(void)stopListening{
	self.isListening = NO;
	[_request commitVoice];
}

-(void)processResponse:(id)response{
	NSLog(@"%@",response);
	NSDictionary *answer = (NSDictionary *)response;
	NSDictionary *candidates = [answer objectForKey:@"asr"];
	NSMutableDictionary *phrases = [[HNCache sharedCache]cachedPhrases];
	for (NSString *item in candidates.allKeys) {
		if ([phrases objectForKey:item]) {
			NSString *method = [[phrases objectForKey:item]objectForKey:@"method"];
			NSString *receiver = [[phrases objectForKey:item]objectForKey:@"receiver"];
			if ([method isEqualToString:@"SMS"]) {
				CLLocationCoordinate2D coor = [[[HNLocationManager sharedLocationService]currentLocation]coordinate];
				NSString *message = [NSString stringWithFormat:@"I need help! I'm at %4f,%4f",coor.latitude,coor.longitude];
				[PFCloud callFunction:@"sendSMS" withParameters:@{@"to":receiver,@"message":message}];
			}
			else{
				[PFCloud callFunction:@"makeCall" withParameters:@{@"to":receiver}];
			}
			
		}
	}
}


@end
