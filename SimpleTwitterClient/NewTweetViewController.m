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

@end

@implementation NewTweetViewController

+ (UIViewController *)viewControllerWithNaviBar:(NSString*)initialTweetText {
    NewTweetViewController *newTweetsVC = [[NewTweetViewController alloc] init];
    newTweetsVC.initialTweetText = initialTweetText;
    return [[UINavigationController alloc] initWithRootViewController:newTweetsVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.initialTweetText == nil) {
        self.tweetText.text = @"";
    } else {
        self.tweetText.text = self.initialTweetText;
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
    [client updateStatus:self.tweetText.text completion:^(NSDictionary *response, NSError *error) {
        if (error != nil) {
            NSLog(@"Fail to create a tweet: %@", error);
            return;
        }
        NSLog(@"Tweet id: %@", response[@"id"]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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
