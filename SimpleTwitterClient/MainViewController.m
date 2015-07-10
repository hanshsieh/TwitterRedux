//
//  MainViewController.m
//  TwitterRedux
//
//  Created by Chu-An Hsieh on 7/9/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "MainViewController.h"
#import "UserProfileCell.h"
#import "User.h"
#import "SimpleMenuItemCell.h"
#import "MenuViewController.h"
#import "UserProfileViewController.h"
#import "TweetsViewController.h"
#import "Utils.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) MenuViewController* menuVC;
@end

@implementation MainViewController

NSString * const MENU_ITEM_TYPE_USER_PROFILE = @"user_profile";
NSString * const MENU_ITEM_TYPE_SIMPLE = @"simple";

- (instancetype)init {
    self = [self initWithNibName:NSStringFromClass([HamburgerMenuViewController class]) bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuVC = [[MenuViewController alloc] init];
    [self attachHamburgerMenuVC:self.menuVC];
    [self attachMainVC:[Utils embedNavBarForViewController:[[TweetsViewController alloc] init]]];
    self.menuVC.menuTable.delegate = self;
    self.menuVC.menuTable.dataSource = self;
    [self setupMenuItems];
    [self.menuVC.menuTable registerNib:[UINib nibWithNibName:NSStringFromClass([UserProfileCell class]) bundle:nil]
         forCellReuseIdentifier:MENU_ITEM_TYPE_USER_PROFILE];
    [self.menuVC.menuTable registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleMenuItemCell class]) bundle:nil]
         forCellReuseIdentifier:MENU_ITEM_TYPE_SIMPLE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)menuTable numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)menuTable cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSDictionary *menuItem = self.menuItems[row];
    NSString *type = menuItem[@"type"];
    UITableViewCell *cell = [self.menuVC.menuTable dequeueReusableCellWithIdentifier:type];
    if ([cell isKindOfClass:[UserProfileCell class]]) {
        UserProfileCell *profileCell = (UserProfileCell*) cell;
        User* user = [User currentUser];
        [profileCell setUserName:user.name];
        [profileCell setProfileImageUrl:[NSURL URLWithString:user.profileImageUrl]];
        [profileCell setScreenName:user.screenName];
    } else if ([cell isKindOfClass:[SimpleMenuItemCell class]]) {
        SimpleMenuItemCell *simpleCell = (SimpleMenuItemCell *) cell;
        [simpleCell setTitle:menuItem[@"title"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    void(^actionFunct)() = self.menuItems[row][@"action"];
    if (actionFunct != nil) {
         actionFunct();
    }
}

#pragma mark Setup Menu Items

- (void)setupMenuItems {
    self.menuItems =
    @[
      @{
          @"type": MENU_ITEM_TYPE_USER_PROFILE,
          @"action": ^() {
              UserProfileViewController* vc = [[UserProfileViewController alloc] init];
              vc.user = [User currentUser];
              [self attachMainVC:[Utils embedNavBarForViewController:vc]];
          }
          },
      @{
          @"type": MENU_ITEM_TYPE_SIMPLE,
          @"title": @"Home",
          @"action": ^() {
              TweetsViewController *vc = [[TweetsViewController alloc] init];
              vc.tweetsSourceType = TweetsSourceTypeHomeTimeline;
              [self attachMainVC:[Utils embedNavBarForViewController:vc]];
          }
          },
      @{
          @"type": MENU_ITEM_TYPE_SIMPLE,
          @"title": @"Mentions",
          @"action": ^() {
              TweetsViewController *vc = [[TweetsViewController alloc] init];
              vc.tweetsSourceType = TweetsSourceTypeMentionsTimeline;
              [self attachMainVC:[Utils embedNavBarForViewController:vc]];
          }
          }
      ];
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
