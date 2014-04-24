//
//  RSSearchViewController.m
//  GithubToGo
//
//  Created by Reed Sweeney on 4/21/14.
//  Copyright (c) 2014 Reed Sweeney. All rights reserved.
//

#import "RSSearchViewController.h"
#import "RSWebViewController.h"
#import "RSRepo.h"
#import "RSUser.h"

@interface RSSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic) NSInteger selectedScopeButtonIndex;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSOperationQueue *imageQueue;


@end


@implementation RSSearchViewController

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
    self.imageQueue = [NSOperationQueue new];
    //self.imageQueue.maxConcurrentOperationCount = 1;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.searchResults = [[NSMutableArray alloc] init];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)reposForSearchString:(NSString *)searchString
{
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", searchString]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    
    NSMutableArray *tempArray = [jsonDict objectForKey:@"items"];
    
    for (NSDictionary *tempDict in tempArray) {
        RSRepo *repo = [[RSRepo alloc] init];
        repo.name = [tempDict objectForKey:@"name"];
        repo.html_url = [tempDict objectForKey:@"html_url"];
        [self.searchResults addObject:repo];
    }
    [self.tableView reloadData];
}

- (void)usersForSearchString:(NSString *)searchString
{
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/search/users?q=%@", searchString]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
    
    NSMutableArray *tempArray = [jsonDict objectForKey:@"items"];
    
    
    for (NSDictionary *tempDict in tempArray) {
        RSUser *user = [[RSUser alloc] initWithJson:tempDict];
        [self.searchResults addObject:user];
    }
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
    
    if ([self.identifier isEqualToString:@"UserCell"])
    {
        RSUser *user = self.searchResults[indexPath.row];
        if (user.avatarImage)
        {
            cell.imageView.image = user.avatarImage;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"burgerbutton"];
           [user downloadAvatarOnQueue:_imageQueue withCompletionBlock:^{
               [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
           }];
        }
    }
    
    cell.textLabel.text = [self.searchResults[indexPath.row] name];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowGitPage" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedScopeButtonIndex == 1) {
        RSUser *user = self.searchResults[indexPath.row];
        if (!user.avatarImage)
        {
            [user cancelAvatarDownload];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.searchResults removeAllObjects];
    
    if (searchBar.selectedScopeButtonIndex == 0) {
        [self reposForSearchString:searchBar.text];
        self.identifier = @"SearchCell";
    } else if (searchBar.selectedScopeButtonIndex == 1) {
        [self usersForSearchString:searchBar.text];
        self.identifier = @"UserCell";
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)burgerPressed:(id)sender
{
    [self.burgerDelegate handleBurgerPressed];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowGitPage"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSRepo *repo = [self.searchResults objectAtIndex:indexPath.row];
        RSWebViewController *wvc = (RSWebViewController *)segue.destinationViewController;
        wvc.searchResultURL = repo.html_url;
    } 
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end








