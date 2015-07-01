//
//  TwitterClient.m
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 6/29/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"SWomRUh6yFmyrrAi5IRXSQVAo";
NSString * const kTwitterConsumerSecret = @"f6F8xaxU9shzr4oKgphaz2jV2zXDePYZU1wxgm3QxhR5jZ0ji6";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    
    // Make the block to be thread-safe
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"hanstwitterclient://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Get request token, requestToken: %@", requestToken.token);
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        NSLog(@"Auth URl: %@", authURL);
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the reqeust token. error: %@", error);
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL*) url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got the access token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                User *user = [[User alloc] initWithDictionary:responseObject];
                [User setCurrentUser:user];
                NSLog(@"Current user: %@", user.name);
                self.loginCompletion(user, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Fail to get the current user");
                self.loginCompletion(nil, error);
            }];
        /*
        [client GET:@"1.1/statuses/home_timeline.json" parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *tweets = [Tweet tweetsWithArray:responseObject];
                for (Tweet *tweet in tweets) {
                    NSLog(@"=======\nTweet: %@, createdAt: %@\n========", tweet.text, tweet.createdAt);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Fail to get the current user");
            }];*/
    } failure:^(NSError *error) {
        NSLog(@"Fail to get access token");
        self.loginCompletion(nil, error);
    }];

}

- (void)updateStatus:(NSString *)status completion:(void(^)(NSDictionary *body, NSError *error)) completion {
    NSString *url = @"1.1/statuses/update.json";
    NSDictionary *params = @{
                                @"status": status
                             };
    [self POST:url parameters: params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void(^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)createFavoriteForStatus:(NSString *)statusId completion:(void(^)(NSDictionary *body, NSError *error)) completion {
    NSDictionary *params = @{
                             @"id": statusId
                             };
    //NSString *url = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", statusId];
    NSString *url = @"1.1/favorites/create.json";
    [self POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}
@end
