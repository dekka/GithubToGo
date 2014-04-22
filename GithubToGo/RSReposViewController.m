//
//  RSReposViewController.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/21/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSReposViewController.h"
#import "RSAppDelegate.h"

@interface RSReposViewController () <NSURLSessionDelegate>

@property (nonatomic, weak) RSAppDelegate *appDelegate;
@property (nonatomic, weak) RSNetworkController *networkController;

@end

@implementation RSReposViewController

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
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;
    [self.networkController requestOAuthAccess];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)burgerPressed:(id)sender
{
    [self.burgerDelegate handleBurgerPressed];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}



@end
