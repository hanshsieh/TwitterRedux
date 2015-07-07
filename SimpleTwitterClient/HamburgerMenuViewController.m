//
//  HamburgerMenuViewController.m
//  TwitterRedux
//
//  Created by Chu-An Hsieh on 7/7/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "HamburgerMenuViewController.h"

@interface HamburgerMenuViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *hamburgerMenuView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIViewController *mainVC;
@property (strong, nonatomic) UIViewController *hamburgerMenuVC;
@property (assign, nonatomic) BOOL edgePanning;
@property (assign, nonatomic) CGPoint edgePanningTranslation;
@end

@implementation HamburgerMenuViewController

CGFloat const edgePanSize = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgePanning = false;
    if (self.hamburgerMenuVC != nil) {
        [self setSubViewController:self.hamburgerMenuVC fromVC:nil forView:self.hamburgerMenuView];
    }
    if (self.mainVC != nil) {
        [self setSubViewController:self.mainVC fromVC:nil forView:self.mainView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithMainVC:(UIViewController *)mainVC menuVC:(UIViewController*)menuVC {
    self = [super init];
    self.mainVC = mainVC;
    self.hamburgerMenuVC = menuVC;
    return self;
}

- (void)setSubViewController:(UIViewController*) newVC fromVC:(UIViewController *)oldVC forView:(UIView*)view {
    if (newVC == oldVC) {
        return;
    }
    if (oldVC != nil) {
        [oldVC.view removeFromSuperview];
        [oldVC willMoveToParentViewController:nil];
        [oldVC removeFromParentViewController];
        [oldVC didMoveToParentViewController:nil];
    }
    if (newVC != nil) {
        [newVC willMoveToParentViewController:self];
        [self addChildViewController:newVC];
        newVC.view.frame = view.bounds;
        [view addSubview:newVC.view];
        [newVC didMoveToParentViewController:self];
    }
}

- (void)attachHamburgerMenuVC:(UIViewController *)vc {
    [self setSubViewController:vc fromVC:self.hamburgerMenuVC forView:self.hamburgerMenuView];
    self.hamburgerMenuVC = vc;
}

- (void)attachMainVC:(UIViewController *)vc {
    [self setSubViewController:vc fromVC:self.mainVC forView:self.mainView];
    self.mainVC = vc;
}


- (IBAction)onMainViewPan:(UIPanGestureRecognizer*)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint loc = [gesture locationInView:gesture.view];
            if (loc.x <= edgePanSize) {
                self.edgePanning = YES;
                self.edgePanningTranslation = loc;
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (!self.edgePanning) {
                break;
            }
            CGPoint loc = [gesture locationInView:self.view];
            CGFloat newMainManuLeft = loc.x - self.edgePanningTranslation.x;
            CGRect menuBounds = self.hamburgerMenuView.bounds;
            if (newMainManuLeft < 0 || newMainManuLeft > menuBounds.origin.x + menuBounds.size.width) {
                break;
            }
            
            CGFloat newMainMenuCenterX = newMainManuLeft + self.mainView.bounds.size.width / 2;
            self.mainView.center = CGPointMake(newMainMenuCenterX, self.mainView.center.y);
            break;
        }
        default:
            if (!self.edgePanning) {
                break;
            }
            self.edgePanning = false;
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat mainViewLeft = self.mainView.center.x - self.mainView.bounds.size.width / 2;
                CGFloat newMainViewLeft;
                if (mainViewLeft < self.view.center.x) {
                    newMainViewLeft = 0;
                } else {
                    newMainViewLeft = self.hamburgerMenuView.center.x + self.hamburgerMenuView.bounds.size.width / 2;
                }
                self.mainView.center = CGPointMake(newMainViewLeft + self.mainView.bounds.size.width / 2, self.mainView.center.y);
            }];
            break;
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
