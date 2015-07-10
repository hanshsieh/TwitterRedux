//
//  UserProfileViewController.h
//  TwitterRedux
//
//  Created by Chu-An Hsieh on 7/8/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileViewController : UIViewController
@property (strong, nonatomic) User* user;

+ (UIViewController *)viewControllerWithNaviBar;
@end
