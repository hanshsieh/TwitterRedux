//
//  NewTweetViewController.m
//  SimpleTwitterClient
//
//  Created by Chu-An Hsieh on 7/1/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "NewTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface NewTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (assign, nonatomic) NewTweetType tweetType;
@property (strong, nonatomic) Tweet *baseTweet;
@property (weak, nonatomic) IBOutlet UITextView *retweetText;

@end

@implementation NewTweetViewController

+ (UIViewController *)viewControllerWithNaviBar {
    return [self viewControllerWithNaviBarForTweet:nil type:NewTweetTypeNormal];
}

+ (UIViewController *)viewControllerWithNaviBarForTweet:(Tweet*) baseTweet type:(NewTweetType)tweetType; {
    NewTweetViewController *newTweetsVC = [[NewTweetViewController alloc] init];
    newTweetsVC.baseTweet = baseTweet;
    newTweetsVC.tweetType = tweetType;
    return [[UINavigationController alloc] initWithRootViewController:newTweetsVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.retweetText.hidden = YES;
    self.tweetText.text = @"";
    switch (self.tweetType) {
        case NewTweetTypeNormal:
            break;
        case NewTweetTypeReply:
            self.tweetText.text = [NSString stringWithFormat:@"@%@ ", self.baseTweet.user.screenName];
            break;
        case NewTweetTypeRetweet:
            self.retweetText.hidden = NO;
            self.retweetText.text = [NSString stringWithFormat:@"Base tweet: %@", self.baseTweet.text];
            break;
    }
    User *currentUser = [User currentUser];
    [self.userImage setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    self.userName.text = currentUser.name;
    self.screenNameLabel.text = [@"@" stringByAppendingString:currentUser.screenName];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain target:self
                                                                            action:@selector(cancelTweet)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                                                             style:UIBarButtonItemStylePlain target:self
                                                                            action:@selector(newTweet)];
    [self.tweetText becomeFirstResponder];
}

- (void)cancelTweet {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newTweet {
    TwitterClient *client = [TwitterClient sharedInstance];
    switch(self.tweetType) {
        case NewTweetTypeNormal: {
            [client updateStatus:self.tweetText.text parameters:nil completion:^(NSDictionary *body, NSError *error) {
                if (error != nil) {
                    NSLog(@"Fail to create a tweet: %@", error);
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            break;
        }
        case NewTweetTypeReply: {
            [client replyForTweet:self.baseTweet status:self.tweetText.text completion:^(NSDictionary *body, NSError *error) {
                if (error != nil) {
                    NSLog(@"Fail to reply to a tweet: %@", error);
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            break;
        }
        case NewTweetTypeRetweet: {
            [client retweetForTweet:self.baseTweet status:self.tweetText.text completion:^(NSDictionary *body, NSError *error) {
                if (error != nil) {
                    NSLog(@"Fail to create a tweet: %@", error);
                } else {
                    NSLog(@"Retweet succeed");
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            break;
        }
    }
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
