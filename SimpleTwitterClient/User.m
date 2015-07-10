
 //
//  User.m
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 6/30/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

static User* _currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagLine = dictionary[@"description"];
        self.statusesCount = [dictionary[@"statuses_count"] integerValue];
        self.followersCount = [dictionary[@"followers_count"] integerValue];
        self.friendsCount = [dictionary[@"friends_count"] integerValue];
        self.favouritesCount = [dictionary[@"favourites_count"] integerValue];
    }
    return self;
}
+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)user {
    _currentUser = user;
    
    NSData *data = nil;
    if (_currentUser != nil) {
        data = [NSJSONSerialization dataWithJSONObject:_currentUser.dictionary options:0 error:nil];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:kCurrentUserKey];
    [defaults synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
