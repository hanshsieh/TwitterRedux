//
//  TwitterClient.h
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 6/29/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager
+ (TwitterClient *) sharedInstance;
- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL*) url;
- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void(^)(NSArray *tweets, NSError *error))completion;
- (void)retweetForStatus:(NSString*)statusId completion:(void(^)(NSDictionary *body, NSError *error)) completion;
- (void)retweetForTweet:(Tweet*)tweet status:(NSString *)status completion:(void(^)(NSDictionary *body, NSError *error)) completion;
- (void)updateStatus:(NSString *)status parameters: (NSDictionary*)params completion:(void(^)(NSDictionary *body, NSError *error)) completion;
- (void)replyForTweet:(Tweet*)tweet status:(NSString*)status completion:(void(^)(NSDictionary *body, NSError *error)) completion;
- (void)createFavoriteForStatus:(NSString *)statusId completion:(void(^)(NSDictionary *body, NSError *error)) completion;
@end
