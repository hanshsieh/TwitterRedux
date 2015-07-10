//
//  UserProfileViewController.m
//  TwitterRedux
//
//  Created by Chu-An Hsieh on 7/8/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *profilePanGesture;
@property (weak, nonatomic) IBOutlet UIView *profileBackgroundView;
@property (assign, nonatomic) CGSize profileBackgroundViewOriSize;
@property (assign, nonatomic) CGPoint profileBackgroundViewOriCenter;
@property (assign, nonatomic) CGPoint profilePanStartPoint;
@end

@implementation UserProfileViewController

+ (UIViewController *)viewControllerWithNaviBar {
    UserProfileViewController *profileVC = [[UserProfileViewController alloc] init];
    return [[UINavigationController alloc] initWithRootViewController:profileVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fix the problem that the navigation bar overlaps the view
    // See http://stackoverflow.com/questions/17074365/status-bar-and-navigation-bar-appear-over-my-views-bounds-in-ios-7
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Or, you can simply turn off translucent of the navigation bar.
    //self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"User Profile";
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.userNameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.tweetsCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.statusesCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.friendsCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.followersCount];
}

- (void)viewWillAppear:(BOOL)animated {
    self.profileBackgroundViewOriSize = self.profileBackgroundView.bounds.size;
    self.profileBackgroundViewOriCenter = self.profileBackgroundView.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onProfilePan:(UIPanGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.profilePanStartPoint = [gesture locationInView:self.view];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture locationInView:self.view];
        CGFloat disY = MAX(0.0, point.y - self.profilePanStartPoint.y);
        CGRect bounds = self.profileBackgroundView.bounds;
        CGFloat height = self.profileBackgroundViewOriSize.height + disY;
        bounds.size.height = height;
        self.profileBackgroundView.bounds = bounds;
        //CGFloat centerY = height / self.profileBackgroundViewOriSize.height * self.profileBackgroundViewOriCenter.y;
        //self.profileBackgroundView.center = CGPointMake(self.profileBackgroundView.center.x, centerY);
        //CGFloat scale = MAX(1.0, 1.0 + disY / self.profileBackgroundViewOriSize.height);
        //self.profileBackgroundView.transform = CGAffineTransformMakeScale(1.0, scale);
    } else {
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
