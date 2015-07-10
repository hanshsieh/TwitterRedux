//
//  TweetsViewController.m
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 6/30/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "NewTweetViewController.h"
#import "TweetDetailsViewController.h"
#import "UserProfileViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tweetsList;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TweetsViewController

NSString * const TWEET_CELL = @"TweetCell";

+ (UIViewController *)viewControllerWithNaviBar {
    TweetsViewController *tweetsVC = [[TweetsViewController alloc] init];
    return [[UINavigationController alloc] initWithRootViewController:tweetsVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fix the problem that navigation bar overlaps the view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                             style:UIBarButtonItemStylePlain target:self
                                             action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                            style:UIBarButtonItemStylePlain target:self
                                            action:@selector(newTweet)];
    [self.tweetsList registerNib:[UINib nibWithNibName: NSStringFromClass([TweetCell class]) bundle:nil] forCellReuseIdentifier:TWEET_CELL];
    self.tweetsList.dataSource = self;
    self.tweetsList.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refreshControl addTarget:self action: @selector(refresh:) forControlEvents: UIControlEventValueChanged];
    [self.tweetsList addSubview:self.refreshControl];
    
    [self fetchTweets];
}

- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    [self fetchTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark callback

- (void)logout {
    [User logout];
}

- (void)newTweet {
    [self presentViewController:[NewTweetViewController viewControllerWithNaviBar] animated:YES completion:nil];
}

#pragma mark Load tweets
- (void)fetchTweets {
    NSLog(@"Querying tweets...");
    TwitterClient *client = [TwitterClient sharedInstance];
    
    void(^cb)(NSArray *tweets, NSError *error) = ^(NSArray *tweets, NSError *error){
        [self.refreshControl endRefreshing];
        if (error != nil) {
            NSLog(@"Fail to load tweets: %@", error);
            return;
        }
        self.tweets = tweets;
        [self.tweetsList reloadData];
    };
    
    switch (self.tweetsSourceType) {
        case TweetsSourceTypeHomeTimeline:
            NSLog(@"Loading home timeline");
            [client homeTimelineWithParams:nil completion:cb];
            break;
        case TweetsSourceTypeMentionsTimeline:
            NSLog(@"Loading mentions timeline");
            [client mentionsTimelineWithParams:nil completion:cb];
            break;
    }
}

#pragma mark Tweets list

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tweets == nil) {
        return 0;
    }
    NSLog(@"Number of tweets: %lu", (unsigned long) self.tweets.count);
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tweetsList dequeueReusableCellWithIdentifier:TWEET_CELL];
    Tweet *tweet = self.tweets[indexPath.row];
    [cell initWithTweet:tweet];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tweetsList deselectRowAtIndexPath:indexPath animated:NO];
    Tweet *tweet = self.tweets[indexPath.row];
    TweetDetailsViewController *vc = [[TweetDetailsViewController alloc] init];
    vc.tweet = tweet;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Tweet operations

- (void)replyTweetForCell:(TweetCell*)cell {
    NSIndexPath *indexPath = [self.tweetsList indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self presentViewController:[NewTweetViewController viewControllerWithNaviBarForTweet:tweet type:NewTweetTypeReply] animated:YES completion:nil];
}
- (void)retweetTweetForCell:(TweetCell*)cell {
    NSIndexPath *indexPath = [self.tweetsList indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    [self presentViewController:[NewTweetViewController viewControllerWithNaviBarForTweet:tweet type:NewTweetTypeRetweet] animated:YES completion:nil];
}
- (void)favoriteTweetForCell:(TweetCell*)cell {
    NSIndexPath *indexPath = [self.tweetsList indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    
    tweet.favouritesCount += 1;
    tweet.favorited = YES;
    [cell initWithTweet:tweet];
    
    TwitterClient *client = [TwitterClient sharedInstance];
    [client createFavoriteForStatus:tweet.id completion:^(NSDictionary *body, NSError *error) {
        if (error != nil) {
            NSLog(@"Fail to create favorite: %@", error);
            tweet.favouritesCount -= 1;
            tweet.favorited = NO;
            [cell initWithTweet:tweet];
        } else {
            NSLog(@"Favorite created!");
        }
    }];
}


- (void)openAuthorProfileForCell:(TweetCell*)cell {
    NSIndexPath *indexPath = [self.tweetsList indexPathForCell:cell];
    Tweet *tweet = self.tweets[indexPath.row];
    UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] init];
    userProfileVC.user = tweet.user;
    [self.navigationController pushViewController:userProfileVC animated:YES];
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
