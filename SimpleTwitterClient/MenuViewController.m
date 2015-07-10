//
//  MenuViewController.m
//  TwitterRedux
//
//  Created by Chu-An Hsieh on 7/8/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Fix the problem that navigation bar overlaps the view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect viewBounds = [self.view bounds];
        viewBounds.origin.y = 18;
        viewBounds.size.height = viewBounds.size.height - 18;
        self.view.frame = viewBounds;
    }
    [super viewWillAppear:animated];
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
