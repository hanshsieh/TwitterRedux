//
//  TweetCell.m
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 6/30/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "TweetCell.h"

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

@end
