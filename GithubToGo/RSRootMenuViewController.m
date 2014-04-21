//
//  RSRootMenuViewController.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/21/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSRootMenuViewController.h"
#import "RSReposViewController.h"
#import "RSSearchViewController.h"
#import "RSUsersViewController.h"

@interface RSRootMenuViewController () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, RSBurgerProtocol>

@property (nonatomic, strong) NSArray *arrayOfViewControllers;
@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, strong) UITapGestureRecognizer *tapToClose;
@property (nonatomic) BOOL menuIsOpen;
@property (nonatomic, weak) IBOutlet UITableView  *tableView;

@end

@implementation RSRootMenuViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupChildViewControllers];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    }

- (void)setupChildViewControllers
{
    RSReposViewController *repoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Repos"];
    repoViewController.title = @"My Repos";
    repoViewController.burgerDelegate = self;
    RSUsersViewController *usersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Users"];
    usersViewController.title = @"Following";
    usersViewController.burgerDelegate = self;
    RSSearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    searchViewController.title = @"Search";
    searchViewController.burgerDelegate = self;
    
    
    
    self.arrayOfViewControllers = @[repoViewController, usersViewController, searchViewController];
    
    self.topViewController = self.arrayOfViewControllers[0];
    
    [self addChildViewController:self.topViewController];
    //    repoViewController.view.frame = self.view.frame;
    [self.view addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
    
    [self setupDragRecognizer];
 
}

- (void)setupDragRecognizer
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    
    panRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)movePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    
    //[[[pan view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [pan translationInView:self.view];
//    CGPoint velocity = [pan velocityInView:self.view];
    
//    NSLog(@" translation: %@", NSStringFromCGPoint(translatedPoint));
//    NSLog(@" velocity: %@", NSStringFromCGPoint(velocity));
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        //self.topViewController.view.center = CGPointMake(<#CGFloat x#>, <#CGFloat y#>)
        
    }
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (translatedPoint.x > 0)
        {
        self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translatedPoint.x, self.topViewController.view.center.y);
        
        [pan setTranslation:CGPointZero inView:self.view];
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3)
        {
            [self openMenu];
        } else {
            [UIView animateWithDuration:.4 animations:^{
                self.topViewController.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                
            }];
        }
    }
}

- (void)openMenu
{
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .75, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
            [self.topViewController.view addGestureRecognizer:self.tapToClose];
            self.menuIsOpen = YES;
        }
    }];

}

- (void)closeMenu:(id)sender
{
    [UIView animateWithDuration:.5 animations:^{
        self.topViewController.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [self.topViewController.view removeGestureRecognizer:self.tapToClose];
        self.menuIsOpen = NO;
    }];
}

-(void)switchToViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:.2 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
        CGRect offScreen = self.topViewController.view.frame;

        [self.topViewController.view removeFromSuperview];
        
        [self.topViewController removeFromParentViewController];
        self.topViewController = self.arrayOfViewControllers[indexPath.row];
        [self addChildViewController:self.topViewController];
        self.topViewController.view.frame = offScreen;
        [self.view addSubview:self.topViewController.view];
        [self.topViewController didMoveToParentViewController:self];
        [self closeMenu:nil];
    }];
    
}

- (void)handleBurgerPressed
{
    if (self.menuIsOpen) {
        [self closeMenu:nil];
    } else {
        [self openMenu];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfViewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.arrayOfViewControllers[indexPath.row] title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self switchToViewControllerAtIndexPath:indexPath];
}

@end










