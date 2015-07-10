//
//  TweetsViewController.h
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 6/30/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TweetsSourceType) {
    TweetsSourceTypeHomeTimeline,
    TweetsSourceTypeMentionsTimeline,
};

@interface TweetsViewController : UIViewController

@property (nonatomic, assign) TweetsSourceType tweetsSourceType;

+ (UIViewController *)viewControllerWithNaviBar;

@end
