//
//  SimpleMenuItemCell.m
//  TwitterRedux
//
//  Created by Chu-An Hsieh on 7/9/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "SimpleMenuItemCell.h"

@interface SimpleMenuItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation SimpleMenuItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitle:(NSString*)title {
    self.titleLabel.text = title;
}
@end
