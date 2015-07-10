//
//  UserProfileCell.h
//  TwitterRedux
//
//  Created by Chu-An Hsieh on 7/8/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileCell : UITableViewCell

- (void)setUserName:(NSString*)userName;
- (void)setProfileImageUrl:(NSURL*)imageUrl;
- (void)setScreenName:(NSString*)screenName;

@end
