//
//  NewTweetViewController.h
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 7/1/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

typedef NS_ENUM(NSInteger, NewTweetType) {
    NewTweetTypeNormal,
    NewTweetTypeReply,
    NewTweetTypeRetweet
};

@interface NewTweetViewController : UIViewController
+ (UIViewController *)viewControllerWithNaviBar;
+ (UIViewController *)viewControllerWithNaviBarForTweet:(Tweet*) baseTweet type:(NewTweetType)tweetType;
@end
