//
//  TweetDetailsViewController.h
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 7/1/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailsViewController : UIViewController
@property (strong, nonatomic) Tweet *tweet;

+ (UIViewController *)viewControllerWithNaviBar:(Tweet*)tweet;
@end
