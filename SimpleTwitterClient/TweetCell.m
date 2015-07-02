//
//  TweetCell.m
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 6/30/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onReplyClicked:(id)sender {
    [self.delegate replyTweetForCell:self];
}
- (IBAction)onRetweetClicked:(id)sender {
    [self.delegate retweetTweetForCell:self];
}
- (IBAction)onFavoriteClicked:(id)sender {
    [self.delegate favoriteTweetForCell:self];
}

- (void)initWithTweet:(Tweet*)tweet {
    [self.userImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    self.userNameLabel.text = tweet.user.name;
    self.tweetTextLabel.text = tweet.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    
    NSString *stringFromDate = [formatter stringFromDate:tweet.createdAt];
    self.timestampLabel.text = stringFromDate;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
    self.favouritesCountLabel.text = [NSString stringWithFormat:@"%ld", tweet.favouritesCount];
    self.favoriteBtn.enabled = ! tweet.favorited;
}

@end
