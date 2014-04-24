//
//  LoginViewController.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/24/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "LoginViewController.h"
#import "RSNetworkController.h"
#import "RSAppDelegate.h"

@interface LoginViewController ()

@property (nonatomic, weak) RSNetworkController *networkController;
@property (nonatomic, weak) RSAppDelegate *appDelegate;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;
    if ([self.networkController checkForOAuthToken]) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}
- (IBAction)login:(id)sender
{
    [self.networkController requestOAuthAccessWithCompletion:^{
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
