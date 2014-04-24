//
//  RSFollowingViewController.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/22/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSFollowingViewController.h"
#import "RSAppDelegate.h"
#import "RSNetworkController.h"
#import "FollowingCell.h"
#import "RSFollowing.h"

@interface RSFollowingViewController () <NSURLSessionDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) RSAppDelegate *appDelegate;
@property (nonatomic, weak) RSNetworkController *networkController;
@property (nonatomic, weak) NSMutableArray *followingArray;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSOperationQueue *followingImageQueue;


@end

@implementation RSFollowingViewController

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
    self.followingImageQueue = [NSOperationQueue new];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSOperationQueue *networkRequest = [NSOperationQueue new];
    [networkRequest addOperationWithBlock:^{
        [self.networkController retrieveFollowingForCurrentUser:^(NSMutableArray *followingArray) {
            self.followingArray = followingArray;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.followingArray count];
}

- (FollowingCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FollowingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FollowingCell" forIndexPath:indexPath];
    
    cell.followingName.text = [self.followingArray[indexPath.row] name];
    RSFollowing *following = self.followingArray[indexPath.row];
    if (following.followingAvatarImage)
    {
        cell.followingAvatar.image = following.followingAvatarImage;
    } else {
        
        cell.followingAvatar.image = [UIImage imageNamed:@"burgerbutton"];
        [following downloadFollowingAvatarOnQueue:_followingImageQueue withCompletionBlock:^{
            
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }
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

@end






