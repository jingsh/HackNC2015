//
//  HNCache.m
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import "HNCache.h"
#import "HNConstants.h"

@interface HNCache ()
@property(nonatomic,strong) NSCache *cache;
@property(nonatomic,strong) NSUserDefaults *userDefaults;
@end

@implementation HNCache
+(instancetype)sharedCache{
	static dispatch_once_t token;
	static HNCache *sharedObject = nil;
	dispatch_once(&token, ^{
		sharedObject = [[self alloc]init];
	});
	return sharedObject;
}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.cache = [[NSCache alloc]init];
		self.userDefaults = [NSUserDefaults standardUserDefaults];
	}
	return self;
}

#pragma - cahced Item
-(NSMutableDictionary *)cachedUsers{
	if ([self.cache objectForKey:HNCacheUserKey]) {
		return [self.cache objectForKey:HNCacheUserKey];
	}
	NSMutableDictionary *dict = [self.userDefaults objectForKey:HNCacheUserKey];
	if (!dict) {
		dict = [NSMutableDictionary dictionary];
	}
	[self setCachedUsers:dict];
	return dict;
}

-(void)setCachedUsers:(NSMutableDictionary *)users{
	[self.cache setObject:users forKey:HNCacheUserKey];
	[self.userDefaults setObject:users forKey:HNCacheUserKey];
	[self.userDefaults synchronize];
}

-(NSMutableDictionary *)cachedPhrases{
	if ([self.cache objectForKey:HNCachePhrasesKey]) {
		return [self.cache objectForKey:HNCachePhrasesKey];
	}
	NSMutableDictionary *dict = [self.userDefaults objectForKey:HNCachePhrasesKey];
	if (!dict) {
		dict = [NSMutableDictionary dictionary];
	}
	[self setCachedPhrases:dict];
	return dict;
}

-(void)setCachedPhrases:(NSMutableDictionary *)phrases{
	[self.cache setObject:phrases forKey:HNCachePhrasesKey];
	[self.userDefaults setObject:phrases forKey:HNCachePhrasesKey];
	[self.userDefaults synchronize];
}

@end
