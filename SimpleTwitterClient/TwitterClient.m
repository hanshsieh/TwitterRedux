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
NSString * const kAppUrlScheme = @"hanstwitterredux";

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
    NSURL *callBackUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://oauth", kAppUrlScheme] ];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:callBackUrl scope:nil success:^(BDBOAuth1Credential *requestToken) {
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

- (void)retweetForStatus:(NSString*)statusId completion:(void(^)(NSDictionary *body, NSError *error)) completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", statusId];
    [self POST:url parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
}

- (void)retweetForTweet:(Tweet*)tweet status:(NSString *)status completion:(void(^)(NSDictionary *body, NSError *error)) completion {
    [self retweetForStatus:tweet.id completion:^(NSDictionary *body, NSError *error) {
        if (error != nil) {
            completion(nil, error);
            return;
        }
        [self updateStatus:status parameters:nil completion:^(NSDictionary *response, NSError *error) {
            completion(response, error);
        }];
    }];
}

- (void)replyForTweet:(Tweet*)tweet status:(NSString*)status completion:(void(^)(NSDictionary *body, NSError *error)) completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tweet.user.name forKey:@"in_reply_to_status_id"];
    [self updateStatus:status parameters:params completion:^(NSDictionary *response, NSError *error) {
        completion(response, error);
    }];
}

- (void)updateStatus:(NSString *)status parameters: (NSDictionary*)params completion:(void(^)(NSDictionary *body, NSError *error)) completion {
    NSString *url = @"1.1/statuses/update.json";
    NSMutableDictionary *allParams = params == nil ? [NSMutableDictionary dictionary] : [params mutableCopy];
    [allParams setObject:status forKey:@"status"];
    [self POST:url parameters: allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request with URL: %@", operation.request.URL);
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
    NSString *url = @"1.1/favorites/create.json";
    [self POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Request with URL: %@", operation.request.URL);
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}
@end
