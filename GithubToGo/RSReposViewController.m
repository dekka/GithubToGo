//
//  RSReposViewController.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/21/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSReposViewController.h"
#import "RSAppDelegate.h"
#import "RSNetworkController.h"

@interface RSReposViewController () <NSURLSessionDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) RSAppDelegate *appDelegate;
@property (nonatomic, weak) RSNetworkController *networkController;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) NSMutableArray *repos;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSOperationQueue *networkRequest = [NSOperationQueue new];
    [networkRequest addOperationWithBlock:^{
        [self.networkController retrieveReposForCurrentUser:^(NSMutableArray *repos) {
            self.repos = repos;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.repos[indexPath.row] name];
//    NSLog(@"cell label: %@", cell.textLabel.text);
    return cell;
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

#pragma mark - RSNetworkControllerDelegate

//- (void)downloadedRepos:(NSMutableArray *)repoResults;
//{
//    self.repos = repoResults;
//    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self.tableView reloadData];
//    }];
//}


@end






