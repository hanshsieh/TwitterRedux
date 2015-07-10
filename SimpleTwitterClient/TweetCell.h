//
//  TweetCell.h
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 6/30/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellProtocol <NSObject>

@required
- (void)replyTweetForCell:(TweetCell*)cell;
- (void)retweetTweetForCell:(TweetCell*)cell;
- (void)favoriteTweetForCell:(TweetCell*)cell;
- (void)openAuthorProfileForCell:(TweetCell*)cell;
@end

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouritesCountLabel;
@property (weak, nonatomic) id<TweetCellProtocol> delegate;

- (void)initWithTweet:(Tweet*)tweet;
@end
