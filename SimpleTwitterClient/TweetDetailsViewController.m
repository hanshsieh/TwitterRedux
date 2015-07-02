//
//  TweetDetailsViewController.m
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 7/1/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NewTweetViewController.h"
#import "TwitterClient.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIButton *retweetBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;

@end

@implementation TweetDetailsViewController

+ (UIViewController *)viewControllerWithNaviBar:(Tweet*)tweet {
    TweetDetailsViewController *tweetsVC = [[TweetDetailsViewController alloc] init];
    tweetsVC.tweet = tweet;
    return [[UINavigationController alloc] initWithRootViewController:tweetsVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.userImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.userNameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.tweetText.text = self.tweet.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yy hh:mm:ss a"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    
    NSString *createAtStr = [formatter stringFromDate:self.tweet.createdAt];
    self.createdAtLabel.text = createAtStr;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                             style:UIBarButtonItemStylePlain target:self
                                                                            action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply"
                                                                              style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(replyTweet)];
    [self.replyBtn addTarget:self action:@selector(replyTweet) forControlEvents:UIControlEventTouchUpInside];
    [self.favoriteBtn addTarget:self action:@selector(createFavorite) forControlEvents:UIControlEventTouchUpInside];
    [self.retweetBtn addTarget:self action:@selector(createRetweet) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createFavorite {
    TwitterClient *client = [TwitterClient sharedInstance];
    [client createFavoriteForStatus:self.tweet.id completion:^(NSDictionary *body, NSError *error) {
        if (error != nil) {
            NSLog(@"Fail to create favorite: %@", error);
        } else {
            NSLog(@"Favorite created!");
        }
    }];
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)replyTweet {
    [self presentViewController:[NewTweetViewController viewControllerWithNaviBarForTweet:self.tweet type:NewTweetTypeReply] animated:YES completion:nil];
}

- (void)createRetweet {
    [self presentViewController:[NewTweetViewController viewControllerWithNaviBarForTweet:self.tweet type:NewTweetTypeRetweet] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
