//
//  NewTweetViewController.h
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 7/1/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface NewTweetViewController : UIViewController
@property (nonatomic, strong) NSString* initialTweetText;
+ (UIViewController *)viewControllerWithNaviBar:(NSString*)initialTweetText;
@end
