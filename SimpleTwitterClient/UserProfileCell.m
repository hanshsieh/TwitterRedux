//
//  UserProfileCell.m
//  TwitterRedux
//
//  Created by Chu-An Hsieh on 7/8/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "UserProfileCell.h"
#import "UIImageView+AFNetworking.h"

@interface UserProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation UserProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserName:(NSString*)userName {
    self.userNameLabel.text = userName;
}
- (void)setProfileImageUrl:(NSURL*)imageUrl {
    [self.profileImage setImageWithURL:imageUrl];
}
- (void)setScreenName:(NSString*)screenName {
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", screenName];
}

- (void)prepareForReuse {
    [self.profileImage cancelImageRequestOperation];
}

@end
