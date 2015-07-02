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

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
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
    /*TwitterClient *client = [TwitterClient sharedInstance];
    [client homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        for (Tweet *tweet in tweets) {
            NSLog(@"Tweets: %@", tweet.text);
        }
    }];*/
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
    [client homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        [self.refreshControl endRefreshing];
        if (error != nil) {
            NSLog(@"Fail to load tweets: %@", error);
            return;
        }
        self.tweets = tweets;
        [self.tweetsList reloadData];
    }];
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
    [cell.userImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    cell.userNameLabel.text = tweet.user.name;
    cell.tweetTextLabel.text = tweet.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    
    NSString *stringFromDate = [formatter stringFromDate:tweet.createdAt];
    cell.timestampLabel.text = stringFromDate;
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
    UIViewController *vc = [TweetDetailsViewController viewControllerWithNaviBar:tweet];
    [self presentViewController:vc animated:YES completion:nil];
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
