//
//  HNCache.h
//  HackNC
//
//  Created by Jing Shan on 10/10/15.
//  Copyright © 2015 Jing Shan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNCache : NSObject

+(instancetype)sharedCache;

-(NSMutableDictionary *)cachedUsers;
-(void)setCachedUsers:(NSMutableDictionary *)users;

-(NSMutableDictionary *)cachedPhrases;
-(void)setCachedPhrases:(NSMutableDictionary *)phrases;

@end
